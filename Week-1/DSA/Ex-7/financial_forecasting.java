public class FinancialForecasting {

    public static double calculateFutureValueRecursive(double presentValue, double annualGrowthRate, int years) {
        if (years == 0) {
            return presentValue;
        }
        return calculateFutureValueRecursive(presentValue * (1 + annualGrowthRate), annualGrowthRate, years - 1);
    }

    public static double calculateFutureValueIterative(double presentValue, double annualGrowthRate, int years) {
        double futureValue = presentValue;
        for (int i = 0; i < years; i++) {
            futureValue *= (1 + annualGrowthRate);
        }
        return futureValue;
    }

    public static void main(String[] args) {
        double presentValue = 1000.0;
        double annualGrowthRate = 0.05;
        int years = 10;

        double futureValueRecursive = calculateFutureValueRecursive(presentValue, annualGrowthRate, years);
        System.out.printf("Recursive: The future value after %d years is: %.2f\n", years, futureValueRecursive);

        double futureValueIterative = calculateFutureValueIterative(presentValue, annualGrowthRate, years);
        System.out.printf("Iterative: The future value after %d years is: %.2f\n", years, futureValueIterative);
    }
}
