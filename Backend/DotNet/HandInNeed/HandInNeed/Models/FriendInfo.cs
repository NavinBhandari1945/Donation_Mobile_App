using System;
using System.Collections.Generic;

namespace HandInNeed.Models;

public partial class FriendInfo
{
    public int Id { get; set; }

    public string Username { get; set; } = null!;

    public string FirendUsername { get; set; } = null!;
}
