using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class CampaignInfo
{
    public CampaignInfo() { }
    public CampaignInfo(
    int CampaignId,
    string Photo,
    string Description,
    string Tittle,
    string Username,
    DateTime CampaignDate,
    int PostId,
    string Video,
    string CampaignFile,
    string file_extension
        )
    {
        this.CampaignId = CampaignId;
        this.Photo = Photo;
        this.Description = Description;
        this.Tittle = Tittle;
        this.Username = Username;
        this.CampaignDate = CampaignDate;
        this.PostId = PostId;
        this.Video = Video;
        this.CampaignFile = CampaignFile;
        this.FileExtension = file_extension;
    }
    public int CampaignId { get; set; }

    [Required]
    public string Photo { get; set; } = null!;

    [Required]
    public string Description { get; set; } = null!;

    [Required]
    public string Tittle { get; set; } = null!;


    [StringLength(100)]
    [Required]
    public string Username { get; set; } = null!;

    [Required]
    public DateTime CampaignDate { get; set; }

    [Required]
    public int PostId { get; set; }

    [Required]
    public string Video { get; set; } = null!;

    [Required]
    public string CampaignFile { get; set; } = null!;

    [Required]
    public string FileExtension { get; set; } = null!;
}
