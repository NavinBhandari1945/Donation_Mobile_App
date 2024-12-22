using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class Signininfo
{
    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    [Required(ErrorMessage = "Email is required.")]
    [EmailAddress(ErrorMessage = "Invalid email address format.")]
    [StringLength(200, ErrorMessage = "Email must be 200 characters or fewer.")]
    public string Email { get; set; } = null!;

    [Required(ErrorMessage = "Phone number is required.")]
    [StringLength(20, ErrorMessage = "Phone number cannot exceed 20 characters.")]
    [RegularExpression(@"^[\s\S]{1,20}$", ErrorMessage = "Phone number must be up to 20 characters and can include any symbol, character, or letter.")]
    public string PhoneNumber { get; set; } = null!;

    [Required(ErrorMessage = "Address is required.")]
    [StringLength(500, ErrorMessage = "Address cannot exceed 500 characters.")]
    public string Address { get; set; } = null!;

    public string Type { get; set; } = null!;

    [Required(ErrorMessage = "Username is required.")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Username must be between 3 and 50 characters.")]
    public string Username { get; set; } = null!;

    [Required(ErrorMessage = "Password is required.")]
    [RegularExpression(@"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,100}$", ErrorMessage = "Password must be between 6 and 100 characters long, and contain at least one letter and one number.")]
    [DataType(DataType.Password)]
    public string Password { get; set; } = null!;

    public string Photo { get; set; } = null!;

    public virtual ICollection<CampaignInfo> CampaignInfos { get; set; } = new List<CampaignInfo>();

    public virtual ICollection<DonationInfo> DonationInfoDonerUsernameNavigations { get; set; } = new List<DonationInfo>();

    public virtual ICollection<DonationInfo> DonationInfoReceiverUsernameNavigations { get; set; } = new List<DonationInfo>();

    public virtual ICollection<FriendInfo> FriendInfoFirendUsernameNavigations { get; set; } = new List<FriendInfo>();

    public virtual ICollection<FriendInfo> FriendInfoUsernameNavigations { get; set; } = new List<FriendInfo>();
}
