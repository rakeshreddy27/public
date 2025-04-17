public class TwoPointers
{
    // Two Pointers Example: Finding a Pair with a Given Sum in a Sorted Array
    public static (int, int)? FindPairWithSum(int[] arr, int targetSum)
    {
        int left = 0, right = arr.Length - 1;

        while (left < right)
        {
            int currentSum = arr[left] + arr[right];
            if (currentSum == targetSum)
            {
                return (arr[left], arr[right]);
            }
            else if (currentSum < targetSum)
            {
                left++;
            }
            else
            {
                right--;
            }
        }

        return null;
    }

    public static void twoPointers() {
        // Sorted array
        int[] arr = { 1, 2, 3, 4, 6, 8, 9 };
        int targetSum = 10;

        var result = FindPairWithSum(arr, targetSum);
        if (result.HasValue)
        {
            Console.WriteLine($"Pair found: ({result.Value.Item1}, {result.Value.Item2})");
        }
        else
        {
            Console.WriteLine("No pair found.");
        }
    }
}