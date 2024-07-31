class Task {
    private int taskId;
    private String taskName;
    private String status;

    public Task(int taskId, String taskName, String status) {
        this.taskId = taskId;
        this.taskName = taskName;
        this.status = status;
    }

    public int getTaskId() {
        return taskId;
    }

    public String getTaskName() {
        return taskName;
    }

    public String getStatus() {
        return status;
    }

    @Override
    public String toString() {
        return "TaskID: " + taskId + ", Name: " + taskName + ", Status: " + status;
    }
}

class Node {
    Task task;
    Node next;

    public Node(Task task) {
        this.task = task;
        this.next = null;
    }
}

public class TaskManagementSystem {
    private Node head;

    public TaskManagementSystem() {
        this.head = null;
    }

    public void addTask(Task task) {
        Node newNode = new Node(task);
        if (head == null) {
            head = newNode;
        } else {
            Node current = head;
            while (current.next != null) {
                current = current.next;
            }
            current.next = newNode;
        }
        System.out.println("Added: " + task);
    }

    public Task searchTask(int taskId) {
        Node current = head;
        while (current != null) {
            if (current.task.getTaskId() == taskId) {
                return current.task;
            }
            current = current.next;
        }
        return null;
    }

    public void traverseTasks() {
        Node current = head;
        while (current != null) {
            System.out.println(current.task);
            current = current.next;
        }
    }

    public boolean deleteTask(int taskId) {
        if (head == null) {
            System.out.println("List is empty.");
            return false;
        }
        if (head.task.getTaskId() == taskId) {
            head = head.next;
            System.out.println("Deleted task with ID: " + taskId);
            return true;
        }
        Node current = head;
        while (current.next != null && current.next.task.getTaskId() != taskId) {
            current = current.next;
        }
        if (current.next != null) {
            current.next = current.next.next;
            System.out.println("Deleted task with ID: " + taskId);
            return true;
        }
        System.out.println("Task not found.");
        return false;
    }

    public static void main(String[] args) {
        TaskManagementSystem tms = new TaskManagementSystem();
        tms.addTask(new Task(1, "Task One", "Incomplete"));
        tms.addTask(new Task(2, "Task Two", "Complete"));
        tms.addTask(new Task(3, "Task Three", "Incomplete"));

        System.out.println("\nAll Tasks:");
        tms.traverseTasks();

        System.out.println("\nSearch for Task with ID 2:");
        Task task = tms.searchTask(2);
        System.out.println(task != null ? task : "Task not found.");

        System.out.println("\nDeleting Task with ID 2:");
        tms.deleteTask(2);

        System.out.println("\nAll Tasks after deletion:");
        tms.traverseTasks();
    }
}
