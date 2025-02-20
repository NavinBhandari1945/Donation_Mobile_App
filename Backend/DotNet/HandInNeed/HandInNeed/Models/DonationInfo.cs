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

    public DonationInfo(int DonateId, string DonerUsername, string ReceiverUsername,
                    int DonateAmount, DateTime DonateDate, int PostId, string PaymentMethod)
    {
        this.DonateId = DonateId;
        this.DonerUsername = DonerUsername;
        this.ReceiverUsername = ReceiverUsername;
        this.DonateAmount = DonateAmount;
        this.DonateDate = DonateDate;
        this.PostId = PostId;
        this.PaymentMethod = PaymentMethod;
    }

}
