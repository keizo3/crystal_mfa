class Mfa::Create < BrowserAction
  route do
    UserForm.update(current_user, {"base32_secret" => TOTP.generate_base32_secret}) do |form, updated_user|
      puts updated_user.base32_secret
    end if current_user.base32_secret.nil?

    redirect to: Mfa::Show
  end
end
