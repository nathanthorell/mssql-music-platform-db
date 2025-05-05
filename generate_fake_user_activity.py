import os
import random
from datetime import datetime, timedelta
import pyodbc
from faker import Faker
from dotenv import load_dotenv


def main() -> None:
    load_dotenv()

    DB_HOST = os.getenv("DB_HOST")
    DB_PORT = os.getenv("DB_PORT")
    DB_NAME = os.getenv("DB_NAME")
    DB_USER = os.getenv("FLYWAY_USER")
    DB_PASSWORD = os.getenv("FLYWAY_PASSWORD")

    # Validate required environment variables
    if not all([DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD]):
        missing_vars = []
        for var_name in [
            "DB_HOST",
            "DB_PORT",
            "DB_NAME",
            "FLYWAY_USER",
            "FLYWAY_PASSWORD",
        ]:
            if not os.getenv(var_name):
                missing_vars.append(var_name)
        raise ValueError(
            f"Missing required environment variables: {', '.join(missing_vars)}"
        )

    connection_string = (
        f"Driver={{ODBC Driver 18 for SQL Server}};"
        f"Server={DB_HOST},{DB_PORT};"
        f"Database={DB_NAME};"
        f"UID={DB_USER};"
        f"PWD={DB_PASSWORD};"
        f"Encrypt=NO;"
        f"TrustServerCertificate=YES;"
    )

    # Setup configuration
    fake = Faker()
    random.seed(42)
    fake.seed_instance(42)

    num_new_users = 10  # Number of new users to create
    include_existing_users = True  # Whether to generate activity for existing users
    min_activities_per_user = 5
    max_activities_per_user = 90
    subscription_codes = ["Free", "Trial", "Pro", "Premium", "Lifetime"]
    activity_types = ["Played", "Skipped", "Liked"]

    # Connect to the database
    print(f"Connecting to: {DB_HOST}:{DB_PORT}/{DB_NAME} as {DB_USER}")
    conn = None
    cursor = None
    try:
        conn = pyodbc.connect(connection_string)
        cursor = conn.cursor()
        print("Connected to database successfully!")

        # Get existing song IDs from the database
        cursor.execute("SELECT Id FROM Song")
        song_ids = [row.Id for row in cursor.fetchall()]

        if not song_ids:
            print("Warning: No songs found in the database. Using demo song IDs 1-18.")
            song_ids = list(range(1, 19))
        else:
            print(f"Found {len(song_ids)} songs in the database.")

        # Get the highest user ID currently in the database
        cursor.execute("SELECT ISNULL(MAX(Id), 0) AS MaxId FROM [User]")
        max_user_id = cursor.fetchone().MaxId

        # Get the highest activity ID currently in the database
        cursor.execute("SELECT ISNULL(MAX(Id), 0) AS MaxId FROM UserActivity")
        max_activity_id = cursor.fetchone().MaxId

        print(f"Starting user generation from ID: {max_user_id + 1}")
        print(f"Starting activity generation from ID: {max_activity_id + 1}")

        existing_users = []
        if include_existing_users:
            existing_users = get_existing_users(cursor)
            print(f"Found {len(existing_users)} existing users")

        new_users = generate_and_insert_users(
            conn, cursor, fake, num_new_users, subscription_codes
        )

        all_users = new_users + existing_users
        if all_users:
            generate_and_insert_user_activities(
                conn,
                cursor,
                fake,
                all_users,
                song_ids,
                min_activities_per_user,
                max_activities_per_user,
                activity_types,
            )

            generate_user_follows(conn, cursor, all_users)
        else:
            print(
                "No users were created or found. Skipping activity and follow generation."
            )

        print("Data generation completed successfully!")

    except Exception as e:
        print(f"An error occurred: {e}")
        if conn:
            conn.rollback()

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
        print("Database connection closed.")


def get_existing_users(cursor):
    """Retrieve existing users from the database"""
    existing_users = []

    try:
        query = """
            SELECT Id, Name, Email, SubscriptionCode, RegistrationDate
            FROM [User]
        """

        cursor.execute(query)

        for row in cursor.fetchall():
            existing_user = {
                "Id": row.Id,
                "Name": row.Name,
                "Email": row.Email,
                "SubscriptionCode": row.SubscriptionCode,
                "RegistrationDate": row.RegistrationDate,
            }
            existing_users.append(existing_user)

        print(f"Retrieved {len(existing_users)} existing users from the database")

    except Exception as e:
        print(f"Error retrieving existing users: {e}")

    return existing_users


def generate_and_insert_users(conn, cursor, fake, num_users, subscription_codes):
    users_created = 0
    created_users = []

    for i in range(num_users):
        name = fake.name()
        email = fake.email()
        subscription_code = random.choice(subscription_codes)
        # Generate registration dates within the past 2 years
        registration_date = fake.date_between(start_date="-2y", end_date="today")

        try:
            query = f"""
                INSERT INTO [User] (
                    Name,
                    Email,
                    SubscriptionCode,
                    RegistrationDate,
                    CreatedBy,
                    CreatedOn
                )
                OUTPUT INSERTED.Id
                VALUES (
                    '{name}',
                    '{email}',
                    '{subscription_code}',
                    '{registration_date}',
                    'DataGenerator',
                    '{datetime.now()}'
                )
            """

            cursor.execute(query)
            user_id = cursor.fetchval()

            if user_id:
                users_created += 1

                conn.commit()

                created_user = {
                    "Id": user_id,
                    "Name": name,
                    "Email": email,
                    "SubscriptionCode": subscription_code,
                    "RegistrationDate": registration_date,
                }
                created_users.append(created_user)

                if users_created % 10 == 0:
                    print(f"Created {users_created} users")
            else:
                print(f"Warning: Could not retrieve ID for user {name}")
                conn.rollback()

        except Exception as e:
            conn.rollback()
            print(f"Error inserting user {name}: {e}")

    print(f"Total users created: {users_created}")
    return created_users


def generate_and_insert_user_activities(
    conn,
    cursor,
    fake,
    users,
    song_ids,
    min_activities_per_user,
    max_activities_per_user,
    activity_types,
):
    activities_created = 0

    for user in users:
        user_id = user["Id"]

        # Random number of activities for this user
        num_activities = random.randint(
            min_activities_per_user, max_activities_per_user
        )
        user_activities_created = 0

        for _ in range(num_activities):
            song_id = random.choice(song_ids)
            activity_type = random.choice(activity_types)

            # Generate a duration only if the activity type is 'Played'
            duration_listened = "NULL"
            if activity_type == "Played":
                # Random duration between 10 seconds and 10 minutes
                seconds = random.randint(10, 600)
                minutes, seconds = divmod(seconds, 60)
                hours, minutes = divmod(minutes, 60)
                duration_listened = f"'{hours:02d}:{minutes:02d}:{seconds:02d}'"

            # Activity date within the last 6 months but after user registration
            earliest_date = max(
                user["RegistrationDate"], datetime.now().date() - timedelta(days=180)
            )
            activity_date = fake.date_between(
                start_date=earliest_date, end_date="today"
            )
            created_on = datetime.combine(activity_date, datetime.min.time())

            try:
                query = f"""
                    INSERT INTO UserActivity (
                        UserId, SongId, ActivityType, DurationListened, CreatedBy, CreatedOn
                    )
                    OUTPUT INSERTED.Id
                    VALUES (
                        {user_id}, {song_id}, '{activity_type}', {duration_listened}, 'DataGenerator', '{created_on}'
                    )
                """

                cursor.execute(query)
                activity_id = cursor.fetchval()

                if activity_id:
                    activities_created += 1
                    user_activities_created += 1

                    # Commit in batches to avoid large transactions
                    if activities_created % 100 == 0:
                        conn.commit()
                        print(f"Created {activities_created} activities")

            except Exception as e:
                conn.rollback()
                print(f"Error inserting activity for user {user_id}: {e}")

        print(
            f"Created {user_activities_created} activities for user {user['Name']} (ID: {user_id})"
        )

        # Commit any remaining activities
        conn.commit()

    print(f"Total activities created: {activities_created}")


def generate_user_follows(conn, cursor, users, max_follows_per_user=5):
    follows_created = 0

    for user in users:
        follower_id = user["Id"]

        # Decide how many other users this user will follow (0 to max_follows_per_user)
        num_follows = random.randint(0, min(max_follows_per_user, len(users) - 1))

        # Get a list of potential users to follow (excluding self)
        potential_follows = [u for u in users if u["Id"] != follower_id]

        if num_follows > 0 and potential_follows:
            # Randomly select users to follow
            users_to_follow = random.sample(
                potential_follows, min(num_follows, len(potential_follows))
            )

            for follow_user in users_to_follow:
                followed_id = follow_user["Id"]

                try:
                    query = f"""
                        INSERT INTO UserFollow (
                            FollowerUserId, FollowedUserId, CreatedBy, CreatedOn
                        )
                        OUTPUT INSERTED.Id
                        VALUES (
                            {follower_id}, {followed_id}, 'DataGenerator', '{datetime.now()}'
                        )
                    """

                    cursor.execute(query)
                    follow_id = cursor.fetchval()

                    if follow_id:
                        follows_created += 1

                        # Commit periodically
                        if follows_created % 50 == 0:
                            conn.commit()
                            print(f"Created {follows_created} user follows")

                except Exception as e:
                    # Skip duplicate follows (in case the unique constraint is hit)
                    if (
                        "duplicate key" in str(e).lower()
                        or "unique constraint" in str(e).lower()
                    ):
                        print(
                            f"Skipping duplicate follow relationship between {follower_id} and {followed_id}"
                        )
                    else:
                        conn.rollback()
                        print(f"Error creating follow relationship: {e}")

    conn.commit()
    print(f"Total user follows created: {follows_created}")


if __name__ == "__main__":
    main()
