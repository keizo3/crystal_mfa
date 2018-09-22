class Mfa::Show < BrowserAction
  get "/mfa" do
  	base32_secret = current_user.base32_secret.to_s
  	diff = TOTP::DEFAULT_TIME_STEP_SECONDS - ((Time.now.epoch_ms / 1000) % TOTP::DEFAULT_TIME_STEP_SECONDS)
    mfa_code = TOTP.generate_number_string(base32_secret)

    render ShowPage , img_url: TOTP.qr_code_url(current_user.email, base32_secret), mfa_code: mfa_code
  end
end
