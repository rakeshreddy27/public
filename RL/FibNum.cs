public class FibNum
{
    public static int fibonacci(int n) {
        var memo = new Dictionary<int, int>();
        return fibonacci_internal(n, memo);
    }

    public static int fibonacci_internal(int n, Dictionary<int, int> memo) {
        if (n <= 1) return n;
        if (memo.ContainsKey(n)) return memo[n];

        memo[n] = fibonacci_internal(n - 1, memo) + fibonacci_internal(n - 2, memo);
        return memo[n];
    }

    public static void fibNum(int n) {
        int result = fibonacci(n);
        Console.WriteLine($"Fibonacci({n}) = {result}");
    }
}