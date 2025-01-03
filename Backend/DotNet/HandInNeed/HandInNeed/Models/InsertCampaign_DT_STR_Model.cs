namespace HandInNeed.Models
{
    public class InsertCampaign_DT_STR_Model
    {
        public int CampaignId { get; set; }

        public string Photo { get; set; } = null!;

        public string Description { get; set; } = null!;

        public string Tittle { get; set; } = null!;

        public string Username { get; set; } = null!;

        public string CampaignDate { get; set; }

        public string PostId { get; set; }

        public string Video { get; set; } = null!;

        public string CampaignFile { get; set; } = null!;

        public string FileExtension { get; set; } = null!;

    }

}
