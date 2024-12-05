using HandInNeed.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;

//Scaffold-DbContext "Server=DESKTOP-8URIDDU\SQLEXPRESS;Database=EFC_DFA_22;Trusted_Connection=True;TrustServerCertificate=true;"
//Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -force

namespace HandInNeed.Controllers
{
    //http://10.0.2.2:5074/api/SignInUser root url

    [Route("api/[controller]")]
    [ApiController]
    public class SignInUserController : ControllerBase
    {
        private readonly HandinneedContext database;
        private readonly ILogger<SignInUserController> _logger;

        public SignInUserController(HandinneedContext database, ILogger<SignInUserController> logger)
        {
            this.database = database;
            this._logger = logger;
        }


        [HttpPost]
        public async Task<ActionResult> SignInUser([FromBody] Signininfo obj)
        {
            try
            {
                if (ModelState.IsValid)
            {
                    var userInfo = await database.Signininfos.ToListAsync();
                    if (userInfo != null) 
                    {
                        foreach (var user_data in userInfo) 
                        {
                            if (obj.Username == user_data.Username)
                            {
                                return BadRequest(ModelState);
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
                    return BadRequest(ModelState); // 400 Bad Request with validation errors
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



    }
}
