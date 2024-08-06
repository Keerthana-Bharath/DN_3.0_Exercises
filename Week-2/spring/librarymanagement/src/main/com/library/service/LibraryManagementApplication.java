package com.library;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import com.library.service.BookService;

public class LibraryManagementApplication {
    public static void main(String[] args) {
        // Load the Spring context from XML configuration
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");

        // Retrieve the BookService bean
        BookService bookService = context.getBean(BookService.class);

        // Test the bean
        bookService.manageBooks();
    }
}
