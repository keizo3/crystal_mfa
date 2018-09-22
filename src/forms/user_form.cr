class UserForm < User::BaseForm
  fillable email
  fillable encrypted_password
  fillable base32_secret
end
