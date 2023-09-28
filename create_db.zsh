#!/bin/zsh

conf_file="flyway.conf"

if [ -f "$conf_file" ]; then
    flyway_url=$(grep '^flyway.url=' "$conf_file" | cut -d'=' -f2-)
    flyway_user=$(grep '^flyway.user=' "$conf_file" | cut -d'=' -f2-)
    flyway_password=$(grep '^flyway.password=' "$conf_file" | cut -d'=' -f2-)
else
    echo "Configuration file not found: $conf_file"
    exit 1
fi

# Verify required configuration values are present
if [ -z "$flyway_url" ] || [ -z "$flyway_user" ] || [ -z "$flyway_password" ]; then
    echo "Missing configuration values in $conf_file"
    exit 1
fi

# Extract server and port from flyway.url
server=$(echo "$flyway_url" | sed -n 's|jdbc:sqlserver://\(.*\):[0-9]*;.*|\1|p')
port=$(echo "$flyway_url" | sed -n 's|jdbc:sqlserver://.*:\([0-9]*\);.*|\1|p')

# Construct the server_url in the format tcp:host,port
server_url="tcp:$server,$port"

# Extract database name from flyway.url
db=$(echo "$flyway_url" | sed -n 's|.*;databaseName=\(.*\);encrypt=.*|\1|p')

# SQL query to check if the database exists
check_db_query="SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name = '$db';"

# Connect to MSSQL and execute the query using sqlcmd
result=$(sqlcmd -S "$server_url" -d "master" -U "$flyway_user" -P "$flyway_password" -h -1 -W -Q "$check_db_query" | tr -d '() ')

if [ $? -eq 0 ] && [ "$result" -eq 1 ]; then
    echo "Database '$db' already exists. Dropping..."

    # SQL query to drop the existing database
    drop_db_query="ALTER DATABASE $db SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE $db;"

    # Connect to MSSQL and execute the query using sqlcmd
    sqlcmd -S "$server_url" -d "master" -U "$flyway_user" -P "$flyway_password" -Q "$drop_db_query"

    if [ $? -eq 0 ]; then
        echo "Database '$db' dropped successfully."
    else
        echo "Failed to drop the database '$db'."
        exit 1
    fi
fi

# SQL query to create a new database
create_db_query="CREATE DATABASE $db;"

# Connect to MSSQL and execute the query
sqlcmd -S "$server_url" -d "master" -U "$flyway_user" -P "$flyway_password" -Q "$create_db_query"

# Update the database data and log file sizes
update_data_file="ALTER DATABASE [$db] MODIFY FILE (NAME=N'$db', SIZE=64MB);"
update_log_file="ALTER DATABASE [$db] MODIFY FILE (NAME=N'""$db""_log', SIZE=64MB);"

sqlcmd -S "$server_url" -d "master" -U "$flyway_user" -P "$flyway_password" -Q "$update_data_file"
sqlcmd -S "$server_url" -d "master" -U "$flyway_user" -P "$flyway_password" -Q "$update_log_file"

if [ $? -eq 0 ]; then
    echo "Database created successfully."
else
    echo "Failed to create the database."
fi
