namespace HandInNeed.Models
{
    public class UsernameVerification
    {
        public string Username { get; set; } = null!;
        public UsernameVerification(String username)
        {
            this.Username = username;
        }

    }
}
