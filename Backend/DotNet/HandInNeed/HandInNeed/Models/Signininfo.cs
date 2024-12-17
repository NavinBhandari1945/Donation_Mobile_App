using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class Signininfo
{
    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string PhoneNumber { get; set; } = null!;

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
}
