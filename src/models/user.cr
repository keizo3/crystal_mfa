class User < BaseModel
  include Carbon::Emailable
  include Authentic::PasswordAuthenticatable

  table :users do
    column email : String
    column encrypted_password : String
    column base32_secret : String?
  end

  def emailable
    Carbon::Address.new(email)
  end
end
