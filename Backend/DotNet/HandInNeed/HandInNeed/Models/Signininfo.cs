using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class Signininfo
{
    [Required(ErrorMessage = "First Name is required.")]
    [StringLength(100, ErrorMessage = "First Name cannot be longer than 100 characters.")]
    public string FirstName { get; set; } = null!;

    [Required(ErrorMessage = "Last Name is required.")]
    [StringLength(100, ErrorMessage = "Last Name cannot be longer than 100 characters.")]
    public string LastName { get; set; } = null!;

    [Required(ErrorMessage = "Email is required.")]
    [EmailAddress(ErrorMessage = "Invalid email address.")]
    [RegularExpression(@"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", ErrorMessage = "Invalid email address.")]
    [StringLength(500, ErrorMessage = "Email cannot be longer than 100 characters.")]
    public string Email { get; set; } = null!;

    [Required(ErrorMessage = "Phone Number is required.")]
    [Phone(ErrorMessage = "Invalid phone number.")]
    [RegularExpression(@"^[\d\s()+-]{1,15}$", ErrorMessage = "Phone Number can only contain digits, spaces, and symbols (+, -, ()). It must be between 1 and 15 characters long.")]
    [StringLength(15, ErrorMessage = "Phone Number cannot be longer than 15 digits.")]
    public string PhoneNumber { get; set; } = null!;

    [Required(ErrorMessage = "Address is required.")]
    [StringLength(500, ErrorMessage = "Address cannot be longer than 250 characters.")]
    public string Address { get; set; } = null!;

    [Required(ErrorMessage = "User Type is required.")]
    [StringLength(100, ErrorMessage = "User Type cannot be longer than 50 characters.")]
    public string Type { get; set; } = null!;

    [Required(ErrorMessage = "Username is required.")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Username must be between 3 and 50 characters.")]
    public string Username { get; set; } = null!;

    [Required(ErrorMessage = "Password is required.")]
    [RegularExpression(@"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,100}$", ErrorMessage = "Password must be between 6 and 100 characters long, and contain at least one letter and one number.")]
    [DataType(DataType.Password)]
    public string Password { get; set; } = null!;

    [Required(ErrorMessage = "Photo is required.")]
    public string Photo { get; set; } = null!;

}
