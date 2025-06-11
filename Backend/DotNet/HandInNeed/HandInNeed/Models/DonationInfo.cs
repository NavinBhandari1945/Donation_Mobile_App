using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class DonationInfo
{

    [Key]
    public int DonateId { get; set; }

    [StringLength(100)]
    [Required]
    public string DonerUsername { get; set; } = null!;


    [StringLength(100)]
    [Required]
    public string ReceiverUsername { get; set; } = null!;

    [Required]
    public int DonateAmount { get; set; }

    [Required]
    public DateTime DonateDate { get; set; }

    [Required]
    public int PostId { get; set; }

    [Required]
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
