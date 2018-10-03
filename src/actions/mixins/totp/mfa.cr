module Totp::Mfa
  DEFAULT_ISSUER = "test-mfa-auth"

  def generate_base32_secret
    TOTP.generate_base32_secret
  end

  def get_mfa_code(base32_secret : String)
    TOTP.generate_number_string(base32_secret)
  end

  def generate_mfa_url(base32_secret : String, accountname : String, issuer = DEFAULT_ISSUER)
    URI.unescape(TOTP.otp_auth_url(issuer + ":" + accountname, base32_secret) + "%26issuer=" + issuer)
  end

  def get_qrcode_data(uri : Uri)
    QRencode::QRcode.new(uri)
  end

  def get_qrcode_data(base32_secret : String, accountname : String, issuer = DEFAULT_ISSUER)
    uri = generate_mfa_url(base32_secret, accountname, issuer)
    QRencode::QRcode.new(uri)
  end

  def validate_mfa_code(base32_secret : String, input_mfa_code : String)
    TOTP.generate_number_string(base32_secret) === input_mfa_code
  end
end
