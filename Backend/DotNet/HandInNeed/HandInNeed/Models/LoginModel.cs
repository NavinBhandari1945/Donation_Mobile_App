using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models
{
    public class LoginModel
    {
        [Required(ErrorMessage = "Username is required.")]
        [StringLength(100, MinimumLength = 3, ErrorMessage = "Username must be between 3 and 50 characters.")]
        public string Username { get; set; } = null!;

        [Required(ErrorMessage = "Password is required.")]
        [RegularExpression(@"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,100}$", ErrorMessage = "Password must be between 6 and 100 characters long, and contain at least one letter and one number.")]
        [DataType(DataType.Password)]
        public string Password { get; set; }=null!;

    }
}
