class Mfa::Show < BrowserAction
  get "/mfa" do
    base32_secret = current_user.base32_secret.to_s
    diff = TOTP::DEFAULT_TIME_STEP_SECONDS - ((Time.now.epoch_ms / 1000) % TOTP::DEFAULT_TIME_STEP_SECONDS)
    mfa_code = TOTP.generate_number_string(base32_secret)

    issuer = "test-mfa"
    uri = URI.unescape(TOTP.otp_auth_url(issuer + ":" + current_user.email, base32_secret) + "%26issuer=" + issuer)
    qrcode_data = QRencode::QRcode.new(uri)

    google_qrcode_url = TOTP.qr_code_url(issuer + "-google:" + current_user.email, base32_secret) + "%26issuer=" + issuer + "-google"

    render ShowPage, img_url: google_qrcode_url, mfa_code: mfa_code, qrcode_data: qrcode_data
  end
end
