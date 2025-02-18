using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models
{
    public class Friend_Add_Remove_Model
    {

        public string Current_User_Username { get; set; } = null!;

        public string Friend_User_Username { get; set; } = null!;

    }
}
