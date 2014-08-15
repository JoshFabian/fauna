class BreedersController < ApplicationController

  # GET /breeders
  def index
    @breeders = User.breeder
  end

end