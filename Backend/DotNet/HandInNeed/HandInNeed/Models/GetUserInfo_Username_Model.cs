using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models
{
    public class GetUserInfo_Username_Model
    {

        [Required(ErrorMessage = "Username is required.")]
        [StringLength(100, MinimumLength = 3, ErrorMessage = "Username must be between 3 and 50 characters.")]
        public string Username { get; set; } = null!;

    }
}
