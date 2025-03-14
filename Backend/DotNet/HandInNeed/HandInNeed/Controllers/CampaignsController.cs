using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HandInNeed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CampaignsController : ControllerBase
    {

        private readonly HandinneedContext database;
        private readonly ILogger<AuthenticationController> logger;
        private readonly IConfiguration configuration;

        public CampaignsController(HandinneedContext database, ILogger<AuthenticationController> logger, IConfiguration configuration)
        {
            this.database = database;
            this.logger = logger;
            this.configuration = configuration;
        }


        [Authorize]
        [HttpGet]
        [Route("getcampaigninfo")]
        public async Task<IActionResult> GetCampaignInfo()
        {
            try
            {
                var CampaignData = await database.CampaignInfos.OrderByDescending(x=>x.CampaignDate).ToListAsync();
                if(CampaignData!=null)
                {
                    return Ok(CampaignData);
                }
                else
                {
                    return StatusCode(700,"No any campagin data available.");
                }
                
            }
            catch (Exception ex)
            {
                return StatusCode(702, ex.Message);
            }
        }

    }
}
