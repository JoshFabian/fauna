class PasswordsController < ApplicationController
  include Loggy

  # GET /users/password/edit?reset_password_token=xxx
  def edit
    @user = User.new
    @user.reset_password_token = params[:reset_password_token]

    respond_to do |format|
      format.html { render(template: "devise/passwords/edit") }
    end
  end

end