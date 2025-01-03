using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;

namespace HandInNeed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ActionsController : ControllerBase
    {
        private readonly HandinneedContext database;
        private readonly ILogger<AuthenticationController> logger;
        private readonly IConfiguration configuration;

        public ActionsController(HandinneedContext database, ILogger<AuthenticationController> logger, IConfiguration configuration)
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


    }
}
