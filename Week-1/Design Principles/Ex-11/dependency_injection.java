interface CustomerRepository {
    String findCustomerById(int id);
}

class CustomerRepositoryImpl implements CustomerRepository {
    @Override
    public String findCustomerById(int id) {
        if (id == 1) {
            return "John Doe";
        } else {
            return "Customer not found";
        }
    }
}

class CustomerService {
    private final CustomerRepository customerRepository;

    public CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    public String getCustomerName(int id) {
        return customerRepository.findCustomerById(id);
    }
}

public class DependencyInjectionExample {
    public static void main(String[] args) {
        CustomerRepository customerRepository = new CustomerRepositoryImpl();

        CustomerService customerService = new CustomerService(customerRepository);

        String customerName = customerService.getCustomerName(1);
        System.out.println("Customer Name: " + customerName);

        String unknownCustomer = customerService.getCustomerName(2);
        System.out.println("Customer Name: " + unknownCustomer);
    }
}
