# Java Movie Database Application

This is a university project demonstrating a Java console application that connects to a movie database and performs operations using JDBC. A key feature of this project is that all business logic is encapsulated within Transact-SQL stored procedures, keeping the Java code clean and focused on application flow.

## Features

* **Database Connectivity**: Connects to a Microsoft Azure SQL database using JDBC.
* **Stored Procedure Logic**: All business logic is handled by the database, not the application.
* **Add New Performer (Method 1)**: Inserts a new performer and estimates their years of experience based on the average experience of performers within a similar age range (+/- 10 years).
* **Add New Performer (Method 2)**: Inserts a new performer and estimates their years of experience based on the minimum experience of performers who worked for a director earning above a certain threshold.
* **Display Performers**: Lists all performers currently in the database.

## Technologies Used

* **Language**: Java
* **Database**: Microsoft Azure SQL
* **Connectivity**: JDBC
* **Database Logic**: Transact-SQL Stored Procedures

## Setup and Installation

### 1. Database Setup
Connect to your Azure SQL instance and run the following scripts from the `database_setup/` folder in order:
1.  **`01_schema_and_data.sql`**: Creates the `Performer`, `Director`, `Movie`, and `Acted` tables and populates them with sample data.
2.  **`02_stored_procedures.sql`**: Creates the stored procedures required by the application.

### 2. Application Setup
1.  Open the project in your favorite Java IDE.
2.  Navigate to `src/com/movieapp/MovieApp.java`.
3.  Update the database connection string variables (`HOSTNAME`, `DBNAME`, `USERNAME`, `PASSWORD`) with your own credentials.
4.  Compile and run the `MovieApp.java` file. Interact with the application via the console menu.
