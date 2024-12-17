using System;
using System.Collections.Generic;

namespace HandInNeed.Models;

public partial class CampaignInfo
{
    public int CampaignId { get; set; }

    public string Photo { get; set; } = null!;

    public string Description { get; set; } = null!;

    public string Tittle { get; set; } = null!;

    public string Username { get; set; } = null!;

    public virtual Signininfo UsernameNavigation { get; set; } = null!;
}
