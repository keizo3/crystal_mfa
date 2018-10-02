class Mfa::ShowPage < MainLayout
  needs img_url : String
  needs mfa_code : String
  needs qrcode_data : QRencode::QRcode
  needs img_assets_url : String

  def content
    h1 "MFA QR code"
    text "Email:  #{@current_user.email}"
    helpful_tips
    qr_code
    generated_qr_code
    br
    br
    text "now mfa code: #{@mfa_code}"
  end

  private def helpful_tips
    h3 "Google API QRcode"
    ul do
      li "imageURL: #{@img_url}"
      img src: @img_url
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
end
