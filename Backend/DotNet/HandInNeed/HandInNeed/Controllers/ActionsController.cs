﻿using HandInNeed.Data;
using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace HandInNeed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ActionsController : ControllerBase
    {

        private readonly DataController database;
        private readonly ILogger<AuthenticationController> logger;
        private readonly IConfiguration configuration;

        public ActionsController(DataController database, ILogger<AuthenticationController> logger, IConfiguration configuration)
        {
            this.database = database;
            this.logger = logger;
            this.configuration = configuration;
        }


        [Authorize]
        [HttpPost]
        [Route("insertpost")]
        public async Task<IActionResult> Insert_Post([FromBody] Insert_Post_DT_STR_Model obj)
        {

            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(700, "validation error");
                }
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {
                    var date_value= DateTime.Parse(obj.DateCreated).ToUniversalTime();
                    PostInfo postInfo = new PostInfo
                        (
                        postId: obj.PostId,
                        username:obj.Username,
                        dateCreated:date_value,
                        description:obj.Description,
                        photo:obj.Photo,
                        video:obj.Video,
                        postFile:obj.PostFile,
                        file_extension: obj.FileExtension
                        );
                    var post_data = await database.PostInfos.AddAsync(postInfo);
                    await database.SaveChangesAsync();
                    return Ok(obj);
                }
                else
                {
                    return StatusCode(701, "user doesn't exist");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(702, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("insertcampaign")]
        public async Task<IActionResult> Insert_Campaign([FromBody] InsertCampaign_DT_STR_Model obj)
        {

            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(700, "validation error");
                }
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {
                    var post_data = await database.PostInfos.FirstOrDefaultAsync(x=>x.PostId.ToString()==obj.PostId);
                    if (post_data != null)
                    {
                        var date_value = DateTime.Parse(obj.CampaignDate).ToUniversalTime();
                        CampaignInfo campaignInfo = new CampaignInfo
                            (
                             CampaignId:obj.CampaignId,
                             Photo:obj.Photo,
                             Description:obj.Description,
                             Tittle:obj.Tittle,
                             Username:obj.Username,
                             CampaignDate:date_value,
                             PostId:(int)Convert.ToInt64(obj.PostId),
                             Video:obj.Video,
                             CampaignFile:obj.CampaignFile,
                             file_extension: obj.FileExtension
                            );
                        var campaign_data = await database.CampaignInfos.AddAsync(campaignInfo);
                        await database.SaveChangesAsync();
                        return Ok(obj);
                    }
                    else
                    {
                        return StatusCode(703,"No such with post id exists.");
                    }

                 
                }
                else
                {
                    return StatusCode(701, "user doesn't exist");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(702, ex.Message);
            }
        }

        [Authorize]
        [HttpGet]
        [Route("getuserinfo")]
        public async Task<IActionResult> Get_User_Info()
        {

            try
            {
                var user_data = await database.Signininfos.ToListAsync();
                if (user_data.Any())
                {
                    return Ok(user_data);
                }
                return StatusCode(500, "Database error while getting user info for action screen.");
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }

        [Authorize]
        [HttpGet]
        [Route("get_ad_info")]
        public async Task<IActionResult> Get_Ad_Info()
        {

            try
            {
                var ad_adat = await database.AdvertisementInfos.ToListAsync();
                if (ad_adat.Any())
                {
                    return Ok(ad_adat);
                }
                return StatusCode(500, "Database error while getting ad info for action screen.");
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }


        [Authorize]
        [HttpGet]
        [Route("get_donation_info")]
        public async Task<IActionResult> Get_Donation_Info()
        {
            try
            {
                // Fetch donation info in descending order of DonateAmount
                var ad_adat = await database.DonationInfos
                                            .OrderByDescending(d => d.DonateAmount)
                                            .ToListAsync();

                if (ad_adat.Any())
                {
                    return Ok(ad_adat);
                }
                return NotFound("No donation information found.");
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("get_post_info_qr")]
        public async Task<IActionResult> GetPostInfo(Post_Id_Verification_QR_Model obj)
        {

            try
            {
                var PostData = await database.PostInfos.FirstOrDefaultAsync(x => x.PostId == obj.PostId);
                if (PostData!=null)
                {
                    return Ok(PostData);
                }
                else
                {
                    return StatusCode(700, "No any post data available.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(702, ex.Message);
            }
        }




    }
}
