using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace HandInNeed.Models;

public partial class HandinneedContext : DbContext
{
    public HandinneedContext()
    {
    }

    public HandinneedContext(DbContextOptions<HandinneedContext> options)
        : base(options)
    {
    }

    public virtual DbSet<CampaignInfo> CampaignInfos { get; set; }

    public virtual DbSet<DonationInfo> DonationInfos { get; set; }

    public virtual DbSet<FriendInfo> FriendInfos { get; set; }

    public virtual DbSet<PostInfo> PostInfos { get; set; }

    public virtual DbSet<Signininfo> Signininfos { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=DESKTOP-8URIDDU\\SQLEXPRESS;Database=handinneed;Trusted_Connection=True;TrustServerCertificate=true;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CampaignInfo>(entity =>
        {
            entity.HasKey(e => e.CampaignId);

            entity.ToTable("campaign_info");

            entity.Property(e => e.CampaignId).HasColumnName("campaign_id");
            entity.Property(e => e.CampaignDate)
                .HasColumnType("datetime")
                .HasColumnName("campaign_date");
            entity.Property(e => e.CampaignFile)
                .IsUnicode(false)
                .HasColumnName("campaign_file");
            entity.Property(e => e.Description)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.FileExtension)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("file_extension");
            entity.Property(e => e.Photo)
                .IsUnicode(false)
                .HasColumnName("photo");
            entity.Property(e => e.PostId).HasColumnName("postId");
            entity.Property(e => e.Tittle)
                .IsUnicode(false)
                .HasColumnName("tittle");
            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("username");
            entity.Property(e => e.Video)
                .IsUnicode(false)
                .HasColumnName("video");
        });

        modelBuilder.Entity<DonationInfo>(entity =>
        {
            entity.HasKey(e => e.DonateId);

            entity.ToTable("donation_info");

            entity.Property(e => e.DonateId).HasColumnName("donate_id");
            entity.Property(e => e.DonateAmount).HasColumnName("donate_amount");
            entity.Property(e => e.DonateDate)
                .HasColumnType("datetime")
                .HasColumnName("donate_date");
            entity.Property(e => e.DonerUsername)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("doner_username");
            entity.Property(e => e.PaymentMethod)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("payment_method");
            entity.Property(e => e.PostId).HasColumnName("post_id");
            entity.Property(e => e.ReceiverUsername)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("receiver_username");
        });

        modelBuilder.Entity<FriendInfo>(entity =>
        {
            entity.ToTable("friend_info");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.FirendUsername)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("firend_username");
            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("username");
        });

        modelBuilder.Entity<PostInfo>(entity =>
        {
            entity.HasKey(e => e.PostId);

            entity.ToTable("post_info");

            entity.Property(e => e.PostId).HasColumnName("post_id");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.Description)
                .IsUnicode(false)
                .HasColumnName("description");
            entity.Property(e => e.FileExtension)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("file_extension");
            entity.Property(e => e.Photo)
                .IsUnicode(false)
                .HasColumnName("photo");
            entity.Property(e => e.PostFile)
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasColumnName("post_file");
            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("username");
            entity.Property(e => e.Video)
                .IsUnicode(false)
                .HasColumnName("video");
        });

        modelBuilder.Entity<Signininfo>(entity =>
        {
            entity.HasKey(e => e.Username).HasName("PK__signinin__F3DBC57350EC2DD7");

            entity.ToTable("signininfo");

            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("username");
            entity.Property(e => e.Address)
                .IsUnicode(false)
                .HasColumnName("address");
            entity.Property(e => e.Email)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("first_name");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("last_name");
            entity.Property(e => e.Password)
                .IsUnicode(false)
                .HasColumnName("password");
            entity.Property(e => e.PhoneNumber)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("phone_number");
            entity.Property(e => e.Photo)
                .IsUnicode(false)
                .HasColumnName("photo");
            entity.Property(e => e.Type)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("type");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
