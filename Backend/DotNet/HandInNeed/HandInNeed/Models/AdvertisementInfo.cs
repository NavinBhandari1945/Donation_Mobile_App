using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class AdvertisementInfo
{
    public int AdId { get; set; }

    [Required]
    public string AdPhoto { get; set; } = null!;

    [Required]
    public string AdUrl { get; set; } = null!;
}
