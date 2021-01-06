module Totp::Qrcode
  include StumpyPNG
  include Totp::Mfa

  def generate_qrcode_image(image_path : String, base32_secret : String, accountname : String, issuer = DEFAULT_ISSUER)
    generate_qrcode_image(image_path, get_qrcode_data(base32_secret, accountname, issuer))
  end

  def generate_qrcode_image_base64(base32_secret : String, accountname : String, issuer = DEFAULT_ISSUER)
    qrcode_data = get_qrcode_data(base32_secret, accountname, issuer)
    generate_qrcode_image("", qrcode_data, true)
  end

  def generate_qrcode_image(image_path : String, qrcode_data : QRencode::QRcode, base64 = false)
    canvas = Canvas.new(qrcode_data.width * 4, qrcode_data.width * 4)
    black = RGBA.from_rgb_n(0, 0, 0, 8)
    white = RGBA.from_rgb_n(255, 255, 255, 8)

    row_idx = 0
    strech = 4
    qrcode_data.each_row do |row|
      row.each_with_index do |byte, col_idx|
        color = QRencode::Util.black?(byte) ? black : white

        # 1dot strech to 4*4 dot
        (0...strech).each do |dot_row|
          (0...strech).each do |dot_col|
            canvas[col_idx * strech + dot_col, row_idx + dot_row] = color
          end
        end
      end
      row_idx = row_idx + strech
    end

    if base64 == true
      io = IO::Memory.new
      StumpyPNG.write(canvas, io)
      Base64.encode(io.to_s)
    else
      StumpyPNG.write(canvas, "public" + image_path)
    end
  end
end
