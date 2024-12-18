using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using KIMPACK.Models;

namespace KIMPACK.Pages.Account
{
    public class LoginModel(SignInManager<AppUser> signInManager, UserManager<AppUser> userManager) : PageModel
    {
        private readonly SignInManager<AppUser> _signInManager = signInManager;
        private readonly UserManager<AppUser> _userManager = userManager;

        [BindProperty]
        public required LoginVM Model { get; set; }

        public required string ReturnUrl { get; set; }

        public void OnGet(string? returnUrl = null)
        {
            ReturnUrl = returnUrl ?? Url.Content("~/");
        }

        public async Task<IActionResult> OnPostAsync(string? returnUrl = null)
        {
            ReturnUrl = returnUrl ?? Url.Content("~/");

            if (ModelState.IsValid)
            {
#pragma warning disable CS8604 // Possible null reference argument.
                var result = await _signInManager.PasswordSignInAsync(Model.Username, Model.Password, Model.RememberMe, false);
#pragma warning restore CS8604 // Possible null reference argument.
                if (result.Succeeded)
                {
                    return RedirectToLocal(ReturnUrl);
                }

                ModelState.AddModelError(string.Empty, "Invalid login attempt.");
            }

            return Page();
        }

        private IActionResult RedirectToLocal(string returnUrl)
        {
            return !string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl)
                ? Redirect(returnUrl)
                : RedirectToPage("/Index");
        }
    }
}
