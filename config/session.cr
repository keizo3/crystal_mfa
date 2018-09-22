require "./server"

Lucky::Session::Store.configure do
  settings.key = "my_blog"
  settings.secret = Lucky::Server.settings.secret_key_base
end
