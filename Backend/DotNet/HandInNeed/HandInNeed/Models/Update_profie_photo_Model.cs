using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models
{
    public class Update_profie_photo_Model
    {
        [Required]
        public string Photo { get; set; } = null!;

        [Required(ErrorMessage = "Username is required.")]
        [StringLength(100, MinimumLength = 3, ErrorMessage = "Username must be between 3 and 50 characters.")]
        public string Username { get; set; } = null!;
    }
}
