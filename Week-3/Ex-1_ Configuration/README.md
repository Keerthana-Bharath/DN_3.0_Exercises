# Employee Management System

## Project Overview

This project is an Employee Management System built with Spring Boot. It allows you to manage employee data, departments, and their relationships.

## Setup and Configuration

### `application.properties`

Configure the H2 database and enable the H2 console by adding the following properties to your `application.properties` file:

```properties
# H2 Database Configuration
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=password
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect

# Enable H2 Console
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

### Adding Static Content

To add a static HTML page, create an `index.html` file and place it in the `src/main/resources/static` directory. This file will be served as the default homepage for the application.

For example, you can place your `index.html` file at:
```
src/main/resources/static/index.html
```

### Accessing the H2 Console

Once your application is running, you can access the H2 database console through the following URL:

[http://localhost:8080/h2-console](http://localhost:8080/h2-console)

Log in with the following credentials:
- **JDBC URL**: `jdbc:h2:mem:testdb`
- **User Name**: `sa`
- **Password**: `password`

## Running the Application

To run the application, use the following Maven command:

```bash
mvn spring-boot:run
```

Alternatively, you can run the application from your IDE.

## Troubleshooting

- **404 Error for H2 Console**: Ensure the application is running and the `spring.h2.console.enabled` property is set to `true` in `application.properties`.
- **Unresolved Compilation Problems**: Verify that all dependencies are correctly included in your `pom.xml` and refresh the Maven project.

## License

This project is licensed under the MIT License
