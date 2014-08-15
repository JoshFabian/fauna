class BreedersController < ApplicationController

  # GET /breeders
  def index
    @breeders = User.breeder.order("id desc")
  end

end