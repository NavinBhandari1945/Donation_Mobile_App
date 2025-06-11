using HandInNeed.Models;
using Microsoft.EntityFrameworkCore;

namespace HandInNeed.Data
{
    public class DataController :DbContext
    {

        public DataController(DbContextOptions<DataController> options) : base(options)
        {


        }

        public  DbSet<AdvertisementInfo> AdvertisementInfos { get; set; }

        public  DbSet<CampaignInfo> CampaignInfos { get; set; }

        public  DbSet<DonationInfo> DonationInfos { get; set; }

        public  DbSet<Feedback> Feedbacks { get; set; }

        public  DbSet<FriendInfo> FriendInfos { get; set; }

        public  DbSet<Notification> Notifications { get; set; }

        public  DbSet<PostInfo> PostInfos { get; set; }

        public  DbSet<Signininfo> Signininfos { get; set; }




    }
}
