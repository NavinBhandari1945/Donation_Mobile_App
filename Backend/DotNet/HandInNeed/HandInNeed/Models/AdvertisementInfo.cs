using System;
using System.Collections.Generic;

namespace HandInNeed.Models;

public partial class AdvertisementInfo
{
    public int AdId { get; set; }

    public string AdPhoto { get; set; } = null!;

    public string AdUrl { get; set; } = null!;
}
