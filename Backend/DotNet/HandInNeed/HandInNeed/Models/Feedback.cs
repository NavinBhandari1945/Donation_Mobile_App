using System;
using System.Collections.Generic;

namespace HandInNeed.Models;

public partial class Feedback
{
    public int FeedId { get; set; }

    public string FdUsername { get; set; } = null!;

    public string FdDescription { get; set; } = null!;

    public DateTime FdDate { get; set; }

    public string FdImage { get; set; } = null!;

}
