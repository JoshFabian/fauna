class BreedersController < ApplicationController

  # GET /breeders
  def index
    # query = {filter: {term: {breeder: 1}}, sort: {id: 'desc'}}
    # @breeders = User.search(query).page(params[:page]).per(per).records

    @breeders = User.breeder.order("id desc").page(params[:page]).per(per)
  end

  protected

  def per
    2
  end

end