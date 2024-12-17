using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace HandInNeed.Controllers
{


    [Route("api/[controller]")]
    [ApiController]
    public class ProfileController : ControllerBase
    {

        private readonly HandinneedContext database;
        private readonly ILogger<AuthenticationController> _logger;
        private readonly IConfiguration configuration;

        public ProfileController(HandinneedContext database, ILogger<AuthenticationController> logger, IConfiguration configuration)
        {
            this.database = database;
            this._logger = logger;
            this.configuration = configuration;
        }

        [Authorize]
        [HttpPost]
        [Route("getuserinfo")]
        public async Task<IActionResult> VerifyToken([FromBody] GetUserInfo_Username_Model obj)
        {

            try
            {
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {
                    return Ok(user_data);
           
                }
                return StatusCode(500, "Database error while getting user info for profile screen using username.");
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }


        [Authorize]
        [HttpPost]
        [Route("updatephoto")]
        public async Task<IActionResult> Update_profie_photo([FromBody] Update_profie_photo_Model obj)
        {

            try
            {
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {
                    user_data.Photo= obj.Photo;
                    await database.SaveChangesAsync();
                    return Ok(user_data);

                }
                return StatusCode(500, "Database error while getting user info for profile screen using username.");
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }



    }
}
