class AddressesController < ApplicationController
  def index
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    if @address.save!
      render :index
    else
      render :new
    end
  end

  private

  def address_params
    params.require(:address).permit(:name, :latitude, :longtitude, :description, :address)
  end
end
