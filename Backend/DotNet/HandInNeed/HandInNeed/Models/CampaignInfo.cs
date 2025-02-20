using System;
using System.Collections.Generic;

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

    public string Photo { get; set; } = null!;

    public string Description { get; set; } = null!;

    public string Tittle { get; set; } = null!;

    public string Username { get; set; } = null!;

    public DateTime CampaignDate { get; set; }

    public int PostId { get; set; }

    public string Video { get; set; } = null!;

    public string CampaignFile { get; set; } = null!;

    public string FileExtension { get; set; } = null!;
}
