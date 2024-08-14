package com.springb.exp1.repository;

import com.springb.exp1.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, Long> {
    // Custom query methods, if any, go here
    Department findByName(String name);
}
