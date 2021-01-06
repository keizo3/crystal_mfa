class Mfa::ShowPage < MainLayout
  needs google_qrcode_url : String
  needs totp_code : String
  needs qrcode_data : QRencode::QRcode
  needs img_assets_url : String
  needs base64_qrcode_image : String

  def content
    h1 "TOTP QR code"
    text "Email:  #{@current_user.email}"
    helpful_tips
    qr_code
    generated_qr_code
    br
    generated_base64_qr_code
    br
    text "now totp code: #{@totp_code}"
  end

  private def helpful_tips
    h3 "Google API QRcode"
    ul do
      li "imageURL: #{@google_qrcode_url}"
      img src: @google_qrcode_url
    end
  end

  private def qr_code
    h3 "CSS QRcode"
    div class: "qrcode" do
      @qrcode_data.each_row do |row|
        div do
          row.each do |byte|
            span class: QRencode::Util.black?(byte) ? "b" : "w"
          end
        end
      end
    end
  end

  private def generated_qr_code
    h3 "Generated QRcode png"
    img src: @img_assets_url
  end

  private def generated_base64_qr_code
    h3 "Generated QRcode base64"
    img src: "data:image/png;base64," + @base64_qrcode_image
  end
end
