using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class Notification
{
    public Notification(int notId, string notType, string notReceiverUsername, string notMessage, DateTime notDate)
    {
        NotId = notId;
        NotType = notType;
        NotReceiverUsername = notReceiverUsername;
        NotMessage = notMessage;
        NotDate = notDate;
    }

    [Key]
    public int NotId { get; set; }


    [StringLength(200)]
    [Required]
    public string NotType { get; set; } = null!;


    [StringLength(500)]
    [Required]
    public string NotReceiverUsername { get; set; } = null!;

    [Required]
    public string NotMessage { get; set; } = null!;

    [Required]
    public DateTime NotDate { get; set; }

}
