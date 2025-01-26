# Music Platform Example Database

An example database in MSSQL using Flyway for schema migrations

## Local Environment Configuration

Example of environment variables:

```bash
DB_HOST=localhost
DB_PORT=1433
DB_NAME=MusicPlatform
export FLYWAY_URL="jdbc:sqlserver://localhost:1433;databaseName=MusicPlatform;encrypt=false;trustServerCertificate=true"
export FLYWAY_USER=sa
export FLYWAY_PASSWORD=YOUR_SECRET_PASSWORD_HERE
REDGATE_DISABLE_TELEMETRY=true
```

## Create Local MSSQL Server and Database

- For local migration testing you will need a local SQL Server DB instance
- This is easy with Docker.  Example:

    ```text
    docker run -d -e ACCEPT_EULA=Y -e MSSQL_SA_PASSWORD=TestPassword01 -v mssqldata:/var/opt/mssql -p 1433:1433 --name azuresqledge mcr.microsoft.com/azure-sql-edge:latest
    ```

- Flyway requires a database before it can connect.  To speed up this process for development iteration, I've added `create_db.zsh` which connects and checks if the database exists, if so it drops the database then creates a new empty one.

## CI Migrations

Migrations are structured for use with FlywayDB

- For local testing, you will need FlywayDB Community Edition installed
  - [Download FlywayDB](https://flywaydb.org/download/community)

- For local migration testing edit a local `.env` file in this project's root directory with your local connection configuration and then source it.

- Then run `flyway migrate`

## SQL Server Naming Conventions

Below establishes standard naming for SQL Server objects.

### Tables

- Table names should be singular, representing a single row
- Don't embed data type into a name (e.g. PersonNameString)
- Avoid repeating the table name in the column definition (e.g. use Name instead of Volunteer Name in the Volunteer table)
- PascalCase (e.g. VolunteerNote)
- Tables created only to establish many-to-many relationships should simply be the names of the two tables (e.g. StudentClass)
  - Example: A Student can have many Classes, and a Class can have many Students

### Views, Functions, and Procedures

These should be created as [Repeatable Migrations](https://flywaydb.org/documentation/concepts/migrations#repeatable-migrations).  Follow file naming for "repeatableSqlMigrationPrefix" and "sqlMigrationSeparator".

File Naming Example:

- Views: R__schema_vw_MyView.sql
- Functions: R__schema_f_MyFunction.sql
- Procedures: R__schema_usp_MyProcedureName.sql

SQL Object Naming Example:

- Views: schema.vw_MyView
- Functions: schema.f_MyFunction
- Procedures: schema.usp_MyProcedureName

### Constraint Prefixes

- PK for primary key indexes (e.g. PK_Volunteer_VolunteerId)
- UQ for unique indexes other than primary key (UQ_TableName_ColumnName)
- IX for all other indexes (IX_TableName_ColumName)
- FK for foreign constraints (FK_TableName_ReferencedTableName_ColumnName)
- DF for Default constraints
- CK for check constraints
- CIX for clustered indexes
