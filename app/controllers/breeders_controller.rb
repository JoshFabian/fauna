class BreedersController < ApplicationController

  # GET /breeders
  def index
    query = {filter: {term: {breeder: 1}}, sort: {id: 'desc'}}
    @breeders = User.search(query).page(params[:page]).per(per).records
  end

  protected

  def per
    10
  end

end