class AddressesController < ApplicationController
  before_action :find_address, only: [:edit, :update, :destroy]

  def index
    @addresses = Address.all
  end

  def new
    @address = Address.new
  end

  def edit
  end

  def create
    @address = Address.new(address_params)
    if @address.save!
      redirect_to addresses_path
    else
      redirect_to new_address_path
    end
  end

  def destroy
    @address.destroy!
    redirect_to addresses_path
  end

  def update
    @address.update!(address_params)
    redirect_to addresses_path
  end

  def show_all
    @addresses = Address.all
                        .select('latitude as lat, longtitude as lng, address, description')
                        .as_json(only: [:lat, :lng, :address, :description])
  end

  private

  def find_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:name, :latitude, :longtitude, :description, :address)
  end
end
