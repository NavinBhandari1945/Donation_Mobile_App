﻿using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.IdentityModel.Tokens;
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


        [Authorize]
        [HttpPost]
        [Route("check_friend_or_not")]
        public async Task<IActionResult> Check_Friend_Or_Not(Check_Friend_Or_Not_Model obj)
        {

            try
            {
                var IS_Friend_Or_Not = await database.FriendInfos
                 .Where(x => x.Username.Equals(obj.CurrentUserusername) && x.FirendUsername.Equals(obj.FriendUsername))
                 .ToListAsync();

                if (IS_Friend_Or_Not.Any())  // Check if the list contains elements
                {
                    return Ok("Yes friend.");
                }
                else
                {
                    return StatusCode(901, "No friend.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(900, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("addfriend")]
        public async Task<IActionResult> Add_Friend(FriendInfo obj)
        {

            try
            {
                await database.FriendInfos.AddAsync(obj);
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
        [Route("removefriend")]
        public async Task<IActionResult> Remove_Friend(Friend_Add_Remove_Model obj)
        {
            try
            {
                // Check if the friend relationship exists in the database
                var IS_Friend_Or_Not = await database.FriendInfos
                    .Where(x => x.Username == obj.Current_User_Username && x.FirendUsername == obj.Friend_User_Username)
                    .ToListAsync();

                // If no relationship is found, we can return a message stating they are not friends
                if (IS_Friend_Or_Not.Count == 0)
                {
                    return StatusCode(901, "Not friends.");
                }

                // If there are friends, remove the found entries
                database.FriendInfos.RemoveRange(IS_Friend_Or_Not);
                await database.SaveChangesAsync();
                return Ok("Friendship removed successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(900, ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("getfriendinfo")]
        public async Task<IActionResult> GetFriendInfo(UsernameVerification obj)
        {

            try
            {
                var result = await database.FriendInfos.Where(x => x.Username == obj.Username).ToListAsync();
                if (result != null)
                {
                    return Ok(result);
                }
                else
                {
                    return StatusCode(700, "No any friend data available.");
                }
            }
            catch (Exception ex) { 
            
                return StatusCode(702, ex.Message);
            }
        }







    }
}
