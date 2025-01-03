using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HandInNeed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomeController : ControllerBase
    {
        private readonly HandinneedContext database;
        private readonly ILogger<AuthenticationController> logger;
        private readonly IConfiguration configuration;

        public HomeController(HandinneedContext database, ILogger<AuthenticationController> logger, IConfiguration configuration)
        {
            this.database = database;
            this.logger = logger;
            this.configuration = configuration;
        }


        [Authorize]
        [HttpGet]
        [Route("getpostinfo")]
        public async Task<IActionResult> GetPostInfo()
        {

            try
            {
                var PostData=await database.PostInfos.ToListAsync();
                if(PostData!=null)
                {
                    return Ok(PostData);
                }
                else
                {
                    return StatusCode(700,"No any post data available.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(702, ex.Message);
            }
        }


    }
}
