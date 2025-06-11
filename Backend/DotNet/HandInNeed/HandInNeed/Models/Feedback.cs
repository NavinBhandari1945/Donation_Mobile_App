using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class Feedback
{

    [Key]
    public int FeedId { get; set; }

    [StringLength(100)]
    [Required]
    public string FdUsername { get; set; } = null!;

    [Required]
    public string FdDescription { get; set; } = null!;

    [Required]
    public DateTime FdDate { get; set; }

    [Required]
    public string FdImage { get; set; } = null!;

}
