class Customer
  # stripe customer

  # find or create customer attached to the user
  def self.find_or_create(user)
    if user.customer_id.present?
      # find customer object
      customer = Stripe::Customer.retrieve(user.customer_id)
    else
      # create customer object
      customer = Stripe::Customer.create(email: user.email, description: "user:#{user.id}")
      # attach customer to user
      user.update_attributes(customer_id: customer.id)
      customer
    end
  rescue Exception => e
    nil
  end

end