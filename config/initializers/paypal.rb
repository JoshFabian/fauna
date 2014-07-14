# developer.paypal.com
PayPal::SDK.configure(
  mode: Settings[Rails.env][:pp_mode],
  username: Settings[Rails.env][:pp_username],
  password: Settings[Rails.env][:pp_password],
  signature: Settings[Rails.env][:pp_signature],
  app_id: Settings[Rails.env][:pp_app_id]
)

# used with paypal rest gem
# PayPal::SDK::REST.set_config(
#   mode: "sandbox", # "sandbox" or "live"
#   client_id: "AU_B-BDqv4QS0slNBD53BicfWtvMEXnHSmweLzNDTVkoLo_ctbj0R_1aSVkD",
#   client_secret: "EGTQShDpFB5MefwY3hSmmb76adBhonpZvKkGVNzSJDCURWNq31cXv_5vf1os"
# )