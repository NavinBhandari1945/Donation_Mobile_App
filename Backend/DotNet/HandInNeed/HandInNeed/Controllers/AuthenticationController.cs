using HandInNeed.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;


//Scaffold - DbContext "Server=DESKTOP-8URIDDU\SQLEXPRESS;Database=handinneed;Trusted_Connection=True;TrustServerCertificate=true;" Microsoft.EntityFrameworkCore.SqlServer - OutputDir Models - force

namespace HandInNeed.Controllers
{
    //android emulator use 10.0.2.2
    //real device or for web use ipv4 address 
    //modify launchseetins.json file to receive request from any kind of device
    //and we can use ipv4 address for any kind of device

    // http://10.0.2.2:5074/api/Authentication root url

    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController : ControllerBase
    {
        private readonly HandinneedContext database;
        private readonly ILogger<AuthenticationController> _logger;
        private readonly IConfiguration configuration;

        public AuthenticationController(HandinneedContext database, ILogger<AuthenticationController> logger, IConfiguration configuration)
        {
            this.database = database;
            this._logger = logger;
            this.configuration = configuration;
        }


        [HttpGet]
        [Route("jwtverify")]
        [Authorize]
        public async Task<ActionResult> VerifyToken()
        {
            try
            {
                return Ok();
            }
            catch (Exception ex) 
            {
                return StatusCode(500);
            }

        }

        [HttpPost]
        [Route("signin")]
        public async Task<ActionResult> SignInUser([FromBody] Signininfo obj)
        {
            try
            {
                if (ModelState.IsValid)
            {
                    var userInfo = await database.Signininfos.ToListAsync();
                    if (userInfo.Any()) 
                    {
                        foreach (var user_data in userInfo) 
                        {
                            if (obj.Username == user_data.Username)
                            {
                                return StatusCode(502,"The provided user is already registered.");  //same username
                            }
                         
                        }
                        obj.Password = HashPassword(obj.Password);
                        await database.Signininfos.AddAsync(obj);
                        await database.SaveChangesAsync();
                        return Ok(obj); // 200 OK with the object data
                    }
                    else
                    {
                        obj.Password = HashPassword(obj.Password);
                        await database.Signininfos.AddAsync(obj);
                        await database.SaveChangesAsync();
                        return Ok(obj); // 200 OK with the object data
                    }
            }
            else
            {
                    return StatusCode(501,"The provided data is not in correct format."); // 400 Bad Request with validation errors
            }
            }
            catch (Exception ex)
                {
                return StatusCode(500, $"{ex.Message}"); // 500 Internal Server Error
                }

        }

        // Utility method to hash passwords securely
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

        //jwt token resources

        private string GenerateToken()
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                    new Claim("timestamp", DateTime.UtcNow.ToString("o")), // ISO 8601 timestamp for uniqueness
                    new Claim("uniqueId", Guid.NewGuid().ToString())       // Random unique identifier
            };

            var expirationTime = DateTime.UtcNow.AddHours(1);


            var token = new JwtSecurityToken(
                issuer: configuration["Jwt:Issuer"],
                audience: configuration["Jwt:Audience"],
                claims: claims,
                expires:expirationTime,
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> LoginUser([FromBody]LoginModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // Check if the user exists
                    var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);

                    if (user_data != null)
                    {
                        // Validate password (assuming you store hashed passwords)
                        if (user_data.Password == HashPassword(obj.Password))
                        {
                            // Generate token
                            string token = GenerateToken();
                            // Return response
                            return Ok(new
                            {
                                token = token,
                                username = user_data.Username,
                                usertype = user_data.Type
                            });
                        }
                        else
                        {
                            return StatusCode(503,"Invalid password.");
                        }
                    }
                    else
                    {
                        return StatusCode(501,"No user with the provided username not found.");
                    }
                }
                else
                {
                    return StatusCode(502,"Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Exception caught in login action method.\n{ex.Message}"); // 500 Internal Server Error
            }
        }

        [HttpGet]
        [Route("authenticationpostinfo")]
        public async Task<IActionResult> GetPostInfo()
        {
            try
            {
                var PostData = await database.PostInfos.ToListAsync();
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

        [HttpPost]
        [Route("add_feedback")]
        public async Task<IActionResult> Add_Feedback([FromBody] Feedback obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // Check if the user exists
                    var Feedback_Data = await database.Feedbacks.AddAsync(obj);
                    await database.SaveChangesAsync();
                    return Ok("Add feedbak success");

                }
                else
                {
                    return Unauthorized("Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Exception caught in controller add feedback method.{ex.Message}"); // 500 Internal Server Error
            }
        }



    }
}
