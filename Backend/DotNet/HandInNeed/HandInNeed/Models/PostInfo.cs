using System;
using System.Collections.Generic;

namespace HandInNeed.Models;

public partial class PostInfo
{
    public PostInfo(int postId, string username, DateTime dateCreated, string description, string photo, string video, string postFile)
    {
        PostId = postId;
        Username = username;
        DateCreated = dateCreated;
        Description = description;
        Photo = photo;
        Video = video;
        PostFile = postFile;
    }

    public int PostId { get; set; }

    public string Username { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string Description { get; set; } = null!;

    public string Photo { get; set; } = null!;

    public string Video { get; set; } = null!;

    public string PostFile { get; set; } = null!;

}
