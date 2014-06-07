PayPal::SDK.configure(
  mode: "sandbox",  # Set "live" for production
  app_id: "APP-80W284485P519543T",
  username: "sanjay-facilitator_api1.jarna.com",
  password: "1401547109",
  signature: "An5ns1Kso7MWUdW4ErQKJJJ4qi4-ACNpxmL9ouPictklQFjQm.xxds1U",
  client_id: "AU_B-BDqv4QS0slNBD53BicfWtvMEXnHSmweLzNDTVkoLo_ctbj0R_1aSVkD",
  client_secret: "EGTQShDpFB5MefwY3hSmmb76adBhonpZvKkGVNzSJDCURWNq31cXv_5vf1os"
)

# use if we use paypal rest gem
# PayPal::SDK::REST.set_config(
#   mode: "sandbox", # "sandbox" or "live"
#   client_id: "AU_B-BDqv4QS0slNBD53BicfWtvMEXnHSmweLzNDTVkoLo_ctbj0R_1aSVkD",
#   client_secret: "EGTQShDpFB5MefwY3hSmmb76adBhonpZvKkGVNzSJDCURWNq31cXv_5vf1os"
# )