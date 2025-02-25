using System;
using System.Collections.Generic;

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

    public int NotId { get; set; }

    public string NotType { get; set; } = null!;

    public string NotReceiverUsername { get; set; } = null!;

    public string NotMessage { get; set; } = null!;

    public DateTime NotDate { get; set; }

}
