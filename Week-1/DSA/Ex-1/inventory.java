import java.util.HashMap;
import java.util.Map;

class Product {
    private int productId;
    private String productName;
    private int quantity;
    private double price;

    public Product(int productId, String productName, int quantity, double price) {
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.price = price;
    }

    public int getProductId() {
        return productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "ProductID: " + productId + ", Name: " + productName + ", Quantity: " + quantity + ", Price: " + price;
    }
}

class Inventory {
    private Map<Integer, Product> products;

    public Inventory() {
        this.products = new HashMap<>();
    }

    public void addProduct(Product product) {
        if (products.containsKey(product.getProductId())) {
            System.out.println("Product already exists. Use update to modify the product.");
        } else {
            products.put(product.getProductId(), product);
            System.out.println("Added: " + product);
        }
    }

    public void updateProduct(int productId, String productName, Integer quantity, Double price) {
        Product product = products.get(productId);
        if (product != null) {
            if (productName != null) product.setProductName(productName);
            if (quantity != null) product.setQuantity(quantity);
            if (price != null) product.setPrice(price);
            System.out.println("Updated: " + product);
        } else {
            System.out.println("Product not found.");
        }
    }

    public void deleteProduct(int productId) {
        if (products.containsKey(productId)) {
            products.remove(productId);
            System.out.println("Deleted product with ID " + productId);
        } else {
            System.out.println("Product not found.");
        }
    }
}

public class InventoryManagementSystem {
    public static void main(String[] args) {
        Inventory inventory = new Inventory();
        Product p1 = new Product(1, "Laptop", 10, 1000.0);
        inventory.addProduct(p1);
        inventory.updateProduct(1, null, 15, 900.0);
        inventory.deleteProduct(1);
    }
}

