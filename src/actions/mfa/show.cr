include StumpyPNG

class Mfa::Show < BrowserAction
  get "/mfa" do
    base32_secret = current_user.base32_secret.to_s
    diff = TOTP::DEFAULT_TIME_STEP_SECONDS - ((Time.now.epoch_ms / 1000) % TOTP::DEFAULT_TIME_STEP_SECONDS)
    mfa_code = TOTP.generate_number_string(base32_secret)

    issuer = "test-mfa"
    uri = URI.unescape(TOTP.otp_auth_url(issuer + ":" + current_user.email, base32_secret) + "%26issuer=" + issuer)
    qrcode_data = QRencode::QRcode.new(uri)

    # image generate
    img_assets_url = "/assets/images/qrcode.png"
    canvas = Canvas.new(qrcode_data.width * 4 + 1, qrcode_data.width * 4 + 1)
    black = RGBA.from_rgb_n(0, 0, 0, 8)
    white = RGBA.from_rgb_n(255, 255, 255, 8)

    row_idx = 0
    strech = 4
    qrcode_data.each_row do |row|
      row.each_with_index do |byte, col_idx|
        color = QRencode::Util.black?(byte) ? black : white

        # 1dot strech to 4*4 dot
        (0..(strech - 1)).each do |dot_row|
          (0..(strech - 1)).each do |dot_col|
            canvas[col_idx * strech + dot_col, row_idx + dot_row] = color
          end
        end
      end
      row_idx = row_idx + strech
    end
    StumpyPNG.write(canvas, "public" + img_assets_url)

    google_qrcode_url = TOTP.qr_code_url(issuer + "-google:" + current_user.email, base32_secret) + "%26issuer=" + issuer + "-google"

    render ShowPage, img_url: google_qrcode_url, mfa_code: mfa_code, qrcode_data: qrcode_data, img_assets_url: img_assets_url
  end
end
