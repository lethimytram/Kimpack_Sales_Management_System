using KIMPACK.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Threading.Tasks;

namespace CustomIdentity.Pages.Account
{
    public class RegisterModel(UserManager<AppUser> userManager, SignInManager<AppUser> signInManager) : PageModel
    {
        private readonly UserManager<AppUser> _userManager = userManager;
        private readonly SignInManager<AppUser> _signInManager = signInManager;

        [BindProperty]
        public required RegisterVM Model { get; set; }

        public string? ReturnUrl { get; set; }

        public void OnGet(string? returnUrl = null)
        {
            ReturnUrl = returnUrl;
        }

        public async Task<IActionResult> OnPostAsync(string? returnUrl = null)
        {
            ReturnUrl = returnUrl;

            if (ModelState.IsValid)
            {
                var user = new AppUser
                {
                    Name = Model.Name,
                    UserName = Model.Email,
                    Email = Model.Email,
                    Address = Model.Address
                };

#pragma warning disable CS8604 // Possible null reference argument.
                var result = await _userManager.CreateAsync(user, Model.Password);
#pragma warning restore CS8604 // Possible null reference argument.

                if (result.Succeeded)
                {
                    await _signInManager.SignInAsync(user, false);
                    return RedirectToLocal(returnUrl);
                }

                foreach (var error in result.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
            }

            return Page();
        }

        private IActionResult RedirectToLocal(string? returnUrl)
        {
            return !string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl)
                ? Redirect(returnUrl)
                : RedirectToPage("/Index");
        }
    }
}
