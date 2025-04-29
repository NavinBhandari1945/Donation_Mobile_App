using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class Signininfo
{
    [StringLength(100)]
    [Required]
    public string FirstName { get; set; } = null!;

    [StringLength(100)]
    [Required]
    public string LastName { get; set; } = null!;

    [Required]
    public string Email { get; set; } = null!;

    [StringLength(100)]
    [Required]
    public string PhoneNumber { get; set; } = null!;

    [Required]
    public string Address { get; set; } = null!;

    [Required]
    public string Type { get; set; } = null!;

    [StringLength(100)]
    [Required]
    public string Username { get; set; } = null!;

    [Required]
    public string Password { get; set; } = null!;

    [Required]
    public string Photo { get; set; } = null!;
}
