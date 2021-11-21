class AddressesController < ApplicationController
  before_action :find_address, only: [:edit, :update]

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
      render :index
    else
      render :new
    end
  end

  def update
    @address.update!(address_params)
    redirect_to addresses_path
  end

  private

  def find_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:name, :latitude, :longtitude, :description, :address)
  end
end
