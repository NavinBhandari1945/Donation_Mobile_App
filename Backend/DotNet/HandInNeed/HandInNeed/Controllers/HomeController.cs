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
                var PostData=await database.PostInfos.OrderByDescending(x=>x.DateCreated).ToListAsync();
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

        [Authorize]
        [HttpPost]
        [Route("donate")]
        public async Task<ActionResult> Donate([FromBody] Donate_Info_STR_Model obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    int DonateAmount= int.Parse(obj.DonateAmount.ToString());
                    DateTime DonateDate= DateTime.Parse(obj.DonateDate).ToUniversalTime();
                    int PostId=int.Parse(obj.PostId);
                    DonationInfo donationInfo = new DonationInfo
                        (
                    DonateId : obj.DonateId,
                    DonerUsername: obj.DonerUsername,
                    ReceiverUsername: obj.ReceiverUsername,
                    DonateAmount: DonateAmount,
                    DonateDate: DonateDate,
                    PostId:PostId,
                    PaymentMethod: obj.PaymentMethod
                        );
                    var DonationData = await database.DonationInfos.AddAsync(donationInfo);
                    await database.SaveChangesAsync();
                    return Ok();
                }
                else
                {
                    return StatusCode(5001, "Validation failed in model."); // 400 Bad Request with validation errors
                }
            }
            catch (Exception ex)
            {
                return StatusCode(5000, $"{ex.Message}"); // 500 Internal Server Error
            }

        }


        [Authorize]
        [HttpPost]
        [Route("add_notifications")]
        public async Task<ActionResult> Add_Notificatioins([FromBody] Notification obj)
        {
            try
            {
                if (ModelState.IsValid)
                {

                    Notification notification = new Notification(
                       notId:obj.NotId,
                       notType:obj.NotType,
                       notReceiverUsername:obj.NotReceiverUsername ,
                       notMessage:obj.NotMessage,
                       notDate:obj.NotDate
                   );
                    var not_data = await database.Notifications.AddAsync(notification);
                    await database.SaveChangesAsync();
                    return Ok();
                }
                else
                {
                    return StatusCode(5001, "Validation failed in model."); // 400 Bad Request with validation errors
                }
            }
            catch (Exception ex)
            {
                return StatusCode(5000, $"{ex.Message}"); // 500 Internal Server Error
            }

        }





    }
}
