class VenuesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_and_check_user, only: [:show, :edit, :update]

  def show; end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    @venue.user = current_user

    if @venue.save
      redirect_to @venue, notice: 'Buffet cadastrado com sucesso'
    else
      flash[:alert] = "Não foi possível cadastrar o seu buffet."
      render 'new'
    end
  end

  def edit; end
  
  def update
    if @venue.update(venue_params)
      redirect_to @venue, notice: 'Buffet editado com sucesso'
    else
      flash[:alert] = "Não foi possível editar dados do buffet."
      render 'edit'
    end
  end

  def search
    @query = params["query"]
    first_condition = ["brand_name LIKE ? or city LIKE ?", "%#{@query}%", "%#{@query}%"]
    second_condition = ["events.name LIKE ?", "%#{@query}%"]

    @venues = Venue.where(first_condition)
    @venues = @venues.order(:brand_name) if @venues.count > 1

    venues_by_event = Venue.joins(:events).where(second_condition).distinct

    if @venues.empty?
      @venues = venues_by_event
      @venues = @venues.order(:brand_name) if @venues.count > 1
    elsif venues_by_event.any?
      @venues = @venues + venues_by_event
      @venues.uniq!.sort! { |a,b| a.brand_name.downcase <=> b.brand_name.downcase } if @venues.count > 1
    end
  end

  def set_and_check_user
    @venue = Venue.find(params[:id])
    if user_signed_in? && @venue.user != current_user
      return redirect_to venue_path(current_user.venue.id), alert: 'Acesso não permitido!'
    end
  end
  
  private
  def venue_params
    params.require(:venue).permit(:brand_name, 
                                  :corporate_name, 
                                  :registration_number,
                                  :address,
                                  :district, 
                                  :city, 
                                  :state, 
                                  :zip_code, 
                                  :email,
                                  :phone_number,
                                  :description,
                                  :payment_methods)
  end
end
