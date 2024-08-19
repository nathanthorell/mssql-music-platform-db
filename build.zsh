#!/bin/zsh

if [ -f ".env" ]; then
    source .env
else
    echo "Error: .env file not found."
    exit 1
fi

# Read environment variables
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$FLYWAY_USER
DB_PASSWORD=$FLYWAY_PASSWORD

export SQLCMDPASSWORD=$DB_PASSWORD

# Verify required environment variables are present
if [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ] || [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "Missing required environment variables"
    exit 1
fi

# SQL query to check if the database exists
check_db_query="IF DB_ID(N'$DB_NAME') IS NOT NULL PRINT 1"
db_exists=$(sqlcmd -S $DB_HOST,$DB_PORT -U $DB_USER -d master -h -1 -W -s "," -Q $check_db_query)

# Check if database exists
if [ "$db_exists" = "1" ]; then
    echo "Database '$DB_NAME' already exists. Dropping..."

    # SQL query to drop the existing database
    drop_db_query="ALTER DATABASE $DB_NAME SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE $DB_NAME;"

    # Execute the create database query
    sqlcmd -S $DB_HOST,$DB_PORT -U $DB_USER -d master -Q $drop_db_query
fi

echo "Database $DB_NAME does not exist. Creating..."
# SQL query to create the database
create_db_query="CREATE DATABASE [$DB_NAME];"

# Execute the create database query
sqlcmd -S $DB_HOST,$DB_PORT -U $DB_USER -d master -Q $create_db_query

if [ $? -eq 0 ]; then
    echo "Database '$DB_NAME' created successfully."
else
    echo "Failed to create the database."
    exit 1
fi

# Run Flyway migrations
flyway -url="$FLYWAY_URL" -user="$DB_USER" -password="$DB_PASSWORD" migrate

if [ $? -eq 0 ]; then
    echo "Flyway migrations completed successfully."
else
    echo "Flyway migrations failed."
    exit 1
fi
