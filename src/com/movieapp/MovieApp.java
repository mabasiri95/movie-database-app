package com.movieapp;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.Scanner;

public class MovieApp {

    // IMPORTANT: Update these values with your own database credentials
    final static String HOSTNAME = "YOUR_SERVER_HOSTNAME";
    final static String DBNAME = "YOUR_DATABASE_NAME";
    final static String USERNAME = "YOUR_USERNAME";
    final static String PASSWORD = "YOUR_PASSWORD";

    // Database connection string
    final static String URL = String.format(
            "jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
            HOSTNAME, DBNAME, USERNAME, PASSWORD);

    // User input prompt
    final static String PROMPT = 
            "\nPlease select one of the options below: \n" +
            "1) Insert new performer (estimate experience by age); \n" + 
            "2) Insert new performer (estimate experience by director earnings); \n" +
            "3) Display all performers; \n" + 
            "4) Exit";

    public static void main(String[] args) {
        System.out.println("Welcome to the Movie Database Application!");

        try (Scanner sc = new Scanner(System.in)) {
            String option = "";
            while (!option.equals("4")) {
                System.out.println(PROMPT);
                option = sc.next();

                switch (option) {
                    case "1":
                        addPerformerByAge(sc);
                        break;
                    case "2":
                        addPerformerByDirectorEarnings(sc);
                        break;
                    case "3":
                        displayAllPerformers();
                        break;
                    case "4":
                        System.out.println("Exiting application. Goodbye!");
                        break;
                    default:
                        System.out.println(String.format("Unrecognized option: %s. Please try again.", option));
                        break;
                }
            }
        } catch (SQLException e) {
            System.err.println("Database Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void addPerformerByAge(Scanner sc) throws SQLException {
        System.out.println("Please enter Performer ID:");
        int pid = sc.nextInt();
        sc.nextLine(); // Consume newline

        System.out.println("Please enter Performer's name:");
        String pname = sc.nextLine();

        System.out.println("Please enter Performer's age:");
        int age = sc.nextInt();

        System.out.println("Connecting to the database...");
        try (Connection conn = DriverManager.getConnection(URL);
             PreparedStatement stmt = conn.prepareStatement("EXEC add_performer_by_age @pid = ?, @pname = ?, @age = ?;")) {
            
            stmt.setInt(1, pid);
            stmt.setString(2, pname);
            stmt.setInt(3, age);
            
            System.out.println("Dispatching query...");
            stmt.executeUpdate();
            System.out.println("Successfully added new performer.");
        }
    }

    private static void addPerformerByDirectorEarnings(Scanner sc) throws SQLException {
        System.out.println("Please enter Performer ID:");
        int pid = sc.nextInt();
        sc.nextLine(); // Consume newline

        System.out.println("Please enter Performer's name:");
        String pname = sc.nextLine();

        System.out.println("Please enter Performer's age:");
        int age = sc.nextInt();

        System.out.println("Please enter the minimum director earnings:");
        double minEarnings = sc.nextDouble();

        System.out.println("Connecting to the database...");
        try (Connection conn = DriverManager.getConnection(URL);
             PreparedStatement stmt = conn.prepareStatement("EXEC add_performer_by_director_earnings @pid = ?, @pname = ?, @age = ?, @min_earnings = ?;")) {

            stmt.setInt(1, pid);
            stmt.setString(2, pname);
            stmt.setInt(3, age);
            stmt.setDouble(4, minEarnings);
            
            System.out.println("Dispatching query...");
            stmt.executeUpdate();
            System.out.println("Successfully added new performer.");
        }
    }

    private static void displayAllPerformers() throws SQLException {
        System.out.println("Connecting to the database...");
        try (Connection conn = DriverManager.getConnection(URL);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("EXEC display_all_performers;")) {

            System.out.println("\n--- Current Performers ---");
            System.out.printf("%-5s | %-20s | %-22s | %-5s%n", "ID", "Name", "Years of Experience", "Age");
            System.out.println("-----------------------------------------------------------------");

            while (rs.next()) {
                System.out.printf("%-5d | %-20s | %-22d | %-5d%n",
                    rs.getInt("pid"),
                    rs.getString("pname"),
                    rs.getInt("years_of_experience"),
                    rs.getInt("age"));
            }
            System.out.println("-----------------------------------------------------------------");
        }
    }
}