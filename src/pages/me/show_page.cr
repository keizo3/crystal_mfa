class Me::ShowPage < MainLayout
  def content
    h1 "This is your profile"
    helpful_tips
  end

  private def helpful_tips
    h3 "Next, you may want to:"
    ul do
      li "Email:  #{@current_user.email}"
      link "Mfa set up", to: Mfa::Create
    end
  end
end
