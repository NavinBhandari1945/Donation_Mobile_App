using System;
using System.Collections.Generic;

namespace HandInNeed.Models;

public partial class DonationInfo
{
    public int DonateId { get; set; }

    public string DonerUsername { get; set; } = null!;

    public string ReceiverUsername { get; set; } = null!;

    public int DonateAmount { get; set; }

    public DateTime DonateDate { get; set; }

    public int PostId { get; set; }

    public string PaymentMethod { get; set; } = null!;
}
