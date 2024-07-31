import java.util.Arrays;
import java.util.Comparator;

class Book {
    private int bookId;
    private String title;
    private String author;

    public Book(int bookId, String title, String author) {
        this.bookId = bookId;
        this.title = title;
        this.author = author;
    }

    public int getBookId() {
        return bookId;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    @Override
    public String toString() {
        return "BookID: " + bookId + ", Title: " + title + ", Author: " + author;
    }
}

public class LibraryManagementSystem {
    private Book[] books;
    private int count;

    public LibraryManagementSystem(int size) {
        books = new Book[size];
        count = 0;
    }

    public void addBook(Book book) {
        if (count < books.length) {
            books[count] = book;
            count++;
            System.out.println("Added: " + book);
        } else {
            System.out.println("Library is full, cannot add more books.");
        }
    }

    public Book linearSearchByTitle(String title) {
        for (int i = 0; i < count; i++) {
            if (books[i].getTitle().equalsIgnoreCase(title)) {
                return books[i];
            }
        }
        return null;
    }

    public Book binarySearchByTitle(String title) {
        int left = 0;
        int right = count - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            int cmp = books[mid].getTitle().compareToIgnoreCase(title);
            if (cmp == 0) {
                return books[mid];
            } else if (cmp < 0) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return null;
    }

    public void sortBooksByTitle() {
        Arrays.sort(books, 0, count, Comparator.comparing(Book::getTitle, String.CASE_INSENSITIVE_ORDER));
        System.out.println("Books sorted by title.");
    }

    public static void main(String[] args) {
        LibraryManagementSystem lms = new LibraryManagementSystem(10);
        lms.addBook(new Book(1, "The Great Gatsby", "F. Scott Fitzgerald"));
        lms.addBook(new Book(2, "To Kill a Mockingbird", "Harper Lee"));
        lms.addBook(new Book(3, "1984", "George Orwell"));

        System.out.println("\nLinear Search for '1984':");
        Book foundBook = lms.linearSearchByTitle("1984");
        System.out.println(foundBook != null ? foundBook : "Book not found.");

        lms.sortBooksByTitle();

        System.out.println("\nBinary Search for '1984':");
        foundBook = lms.binarySearchByTitle("1984");
        System.out.println(foundBook != null ? foundBook : "Book not found.");
    }
}

