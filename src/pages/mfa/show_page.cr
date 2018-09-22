class Mfa::ShowPage < MainLayout
  needs img_url : String
  needs mfa_code : String

  def content
    h1 "MFA QR code"
    helpful_tips
  end

  private def helpful_tips
    h3 "Next, you may want to:"
    ul do
      li "Email:  #{@current_user.email}"
      li "imageURL:  #{@img_url}"
      img src: @img_url
      li "now mfa code: #{@mfa_code}"
    end
  end
end
