using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class FriendInfo
{
    public int Id { get; set; }


    [StringLength(100)]
    [Required]
    public string Username { get; set; } = null!;


    [StringLength(100)]
    [Required]
    public string FirendUsername { get; set; } = null!;
}
