namespace HandInNeed.Models
{
    public class Insert_Post_DT_STR_Model
    {

        public int PostId { get; set; }

        public string Username { get; set; } = null!;

        public string DateCreated { get; set; }

        public string Description { get; set; } = null!;

        public string Photo { get; set; } = null!;

        public string Video { get; set; } = null!;

        public string PostFile { get; set; } = null!;

        public string FileExtension { get; set; } = null!;

    }
}
