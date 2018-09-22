class Mfa::Create < BrowserAction
  route do
    puts current_user.base32_secret
    UserForm.update(current_user, {"base32_secret" => TOTP.generate_base32_secret}) do |form, updated_user|
      puts updated_user.base32_secret
    end if current_user.base32_secret.nil?

    puts current_user.base32_secret

    redirect to: Mfa::Show
  end
end
