using System;

namespace Palindrome.Domain.Models
{
    public class Palindrome
    {
        public bool IsAPalindrome(string word)
        {
            char[] ch = word.ToCharArray();
            Array.Reverse(ch);
            string rev = new string(ch);
            bool compare = word.Equals(rev, StringComparison.OrdinalIgnoreCase);
            return compare;
        }
    }
}