using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Security.Cryptography;
using System.Text;


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

        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                // Compute hash for the password
                var hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                // Convert the byte array to a hexadecimal string
                return BitConverter.ToString(hashedBytes).Replace("-", "").ToLower();
            }
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
                    Console.WriteLine("console emssage");
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

        [Authorize]
        [HttpPost]
        [Route("updatepassword")]
        public async Task<IActionResult> Update_password([FromBody] UpdatePassword_Model obj)
        {

            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(500,"Validation error");

                }
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {

                    if (user_data.Password == HashPassword(obj.OldPassword))
                    {
                        user_data.Password = HashPassword(obj.NewPassword);
                        await database.SaveChangesAsync();
                        return Ok();
                    }
                    else
                    {
                        return StatusCode(502, "Old password incorrect");
                    }
                }

                else
                {
                    return StatusCode(503, "user doesn't exist");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }



        [Authorize]
        [HttpPost]
        [Route("updateemail")]
        public async Task<IActionResult> Update_Email([FromBody] UpdateEmail_Model obj)
        {

            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(500,"validation error");
                }
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {
                    if(user_data.Email==obj.NewEmail)
                    {
                        return StatusCode(504,"Old email same.");
                    }

                    if (user_data.Password == HashPassword(obj.Password))
                    {
                        user_data.Email = obj.NewEmail;
                        await database.SaveChangesAsync();
                        return Ok();
                    }
                    else
                    {
                        return StatusCode(502, "Old password incorrect");
                    }
                }
                else
                {
                    return StatusCode(503, "user doesn't exist");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("updatephonenumber")]
        public async Task<IActionResult> Update_PhoneNumber([FromBody] Update_PhoneNumber_Model obj)
        {

            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(500, "validation error");
                }
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {
                    if (user_data.PhoneNumber == obj.NewPhoneNumber)
                    {
                        return StatusCode(504, "Old pone number and new phone number  same.");
                    }

                    if (user_data.Password == HashPassword(obj.Password))
                    {
                        user_data.PhoneNumber = obj.NewPhoneNumber;
                        await database.SaveChangesAsync();
                        return Ok();
                    }
                    else
                    {
                        return StatusCode(502, "Old password incorrect");
                    }
                }
                else
                {
                    return StatusCode(503, "user doesn't exist");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }


        [Authorize]
        [HttpPost]
        [Route("updateaddress")]
        public async Task<IActionResult> Update_Address([FromBody] UpdateAddress_Model obj)
        {

            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(500, "validation error");
                }
                var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);
                if (user_data != null)
                {
                    if (user_data.Address == obj.NewAddress)
                    {
                        return StatusCode(504, "Old address and new address same.");
                    }

                    if (user_data.Password == HashPassword(obj.Password))
                    {
                        user_data.Address = obj.NewAddress;
                        await database.SaveChangesAsync();
                        return Ok();
                    }
                    else
                    {
                        return StatusCode(502, "Old password incorrect");
                    }
                }
                else
                {
                    return StatusCode(503, "user doesn't exist");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("getprofilepostinfo")]
        public async Task<IActionResult> GetPostInfo(UsernameVerification obj)
        {

            try
            {
                var PostData = await database.PostInfos.Where(x=>x.Username==obj.Username).ToListAsync();
                if (PostData != null)
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
