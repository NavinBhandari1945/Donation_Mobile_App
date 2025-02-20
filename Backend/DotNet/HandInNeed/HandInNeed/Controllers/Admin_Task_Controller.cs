using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HandInNeed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class Admin_Task_Controller : ControllerBase
    {
        private readonly HandinneedContext database;
        private readonly ILogger<AuthenticationController> _logger;
        private readonly IConfiguration configuration;

        public Admin_Task_Controller(HandinneedContext database, ILogger<AuthenticationController> logger, IConfiguration configuration)
        {
            this.database = database;
            this._logger = logger;
            this.configuration = configuration;
        }

        [Authorize]
        [HttpPost]
        [Route("delete_user")]
        public async Task<IActionResult> Delete_User([FromBody] UsernameVerification obj)
        {

            try
            {
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {

                    var result = database.Signininfos.Remove(user_data);
                    await database.SaveChangesAsync();
                    return Ok("Delete user success");
                }
                else
                {
                    return StatusCode(901, "No user of that username exists.");
                }

            }
            catch (Exception ex)
            {
                return StatusCode(900, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("delete_post")]
        public async Task<IActionResult> Delete_Post([FromBody] Id_Verfication_Model obj)
        {

            try
            {
                var post_data = await database.PostInfos.FirstOrDefaultAsync(x => x.PostId == obj.Id);
                if (post_data != null)
                {

                    var result = database.PostInfos.Remove(post_data);
                    await database.SaveChangesAsync();
                    return Ok("Delete post success");
                }
                else
                {
                    return StatusCode(901, "No post exists.");
                }

            }
            catch (Exception ex)
            {
                return StatusCode(900, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("delete_campaign")]
        public async Task<IActionResult> Delete_Campaign([FromBody] Id_Verfication_Model obj)
        {

            try
            {
                var campaign_data = await database.CampaignInfos.FirstOrDefaultAsync(x => x.CampaignId == obj.Id);
                if (campaign_data != null)
                {

                    var result = database.CampaignInfos.Remove(campaign_data);
                    await database.SaveChangesAsync();
                    return Ok("Delete campaign success");
                }
                else
                {
                    return StatusCode(901, "No campaign exists.");
                }

            }
            catch (Exception ex)
            {
                return StatusCode(900, ex.Message);
            }
        }


        [Authorize]
        [HttpPost]
        [Route("add_ad")]
        public async Task<IActionResult> Add_Ad([FromBody] AdvertisementInfo obj)
        {

            try
            {
                var result = await database.AdvertisementInfos.AddAsync(obj);
                await database.SaveChangesAsync();
                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(900, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("delete_ad")]
        public async Task<IActionResult> Delete_Ad([FromBody] Id_Verfication_Model obj)
        {

            try
            {
                var result = await database.AdvertisementInfos.FirstOrDefaultAsync(x => x.AdId == obj.Id);
                if (result != null)
                {
                    var result1 = database.AdvertisementInfos.Remove(result);
                    await database.SaveChangesAsync();
                    return Ok("Delete advertisement success");
                }
                else
                {
                    return StatusCode(901, "No advertisement exists.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(900, ex.Message);
            }
        }

    }
}
