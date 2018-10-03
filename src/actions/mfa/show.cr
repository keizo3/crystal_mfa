class Mfa::Show < BrowserAction
  include Totp::Mfa
  include Totp::Qrcode

  get "/mfa" do
    # QRcode base64 image generate
    img_assets_url = "/assets/images/qrcode-%s.png" % UUID.random
    base64_qrcode_image = generate_qrcode_image_base64(current_user.base32_secret.to_s, current_user.email)

    # QRcode image generate
    # image use onetime as possible for security
    generate_qrcode_image(img_assets_url, current_user.base32_secret.to_s, current_user.email)

    # sample google API QRcode image generate
    google_qrcode_url = TOTP.qr_code_url("test-mfa-google:" + current_user.email, current_user.base32_secret.to_s) + "%26issuer=test-mfa-google"

    render ShowPage,
      google_qrcode_url: google_qrcode_url,
      mfa_code: get_mfa_code(current_user.base32_secret.to_s),
      qrcode_data: get_qrcode_data(current_user.base32_secret.to_s, current_user.email),
      img_assets_url: img_assets_url,
      base64_qrcode_image: base64_qrcode_image.to_s
  end
end
