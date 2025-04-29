using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HandInNeed.Models;

public partial class PostInfo
{
    public PostInfo() { }
    public PostInfo(int postId, string username, DateTime dateCreated, string description, string photo, string video, string postFile, string file_extension)
    {
        PostId = postId;
        Username = username;
        DateCreated = dateCreated;
        Description = description;
        Photo = photo;
        Video = video;
        PostFile = postFile;
        FileExtension = file_extension;
    }
    public int PostId { get; set; }

    [StringLength(100)]
    [Required]
    public string Username { get; set; } = null!;

    [Required]
    public DateTime DateCreated { get; set; }

    [Required]
    public string Description { get; set; } = null!;

    [Required]
    public string Photo { get; set; } = null!;

    [Required]
    public string Video { get; set; } = null!;

    [Required]
    public string PostFile { get; set; } = null!;

    [Required]
    public string FileExtension { get; set; } = null!;
}
