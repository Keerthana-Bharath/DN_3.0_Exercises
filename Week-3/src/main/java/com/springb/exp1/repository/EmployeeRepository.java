package com.springb.exp1.repository;

import com.springb.exp1.model.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    // Custom query methods, if needed, can be defined here
    Employee findByEmail(String email);
}

