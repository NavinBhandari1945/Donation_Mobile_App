using System;
using System.Collections.Generic;

namespace HandInNeed.Models;

public partial class PostInfo
{
    public int PostId { get; set; }

    public string Username { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string Description { get; set; } = null!;

    public string Photo { get; set; } = null!;

    public string Video { get; set; } = null!;

    public virtual ICollection<DonationInfo> DonationInfos { get; set; } = new List<DonationInfo>();
}
