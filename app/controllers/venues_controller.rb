class VenuesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update active inactive]
  before_action :set_and_check_user, only: %i[show edit update active inactive]

  def show; end

  def new
    @venue = Venue.new
  end

  def edit; end

  def create
    @venue = Venue.new(venue_params)
    @venue.user = current_user

    if @venue.save
      redirect_to @venue, notice: 'Buffet cadastrado com sucesso'
    else
      flash[:alert] = 'Não foi possível cadastrar o seu buffet.'
      render 'new'
    end
  end

  def update
    if @venue.update(venue_params)
      redirect_to @venue, notice: 'Buffet editado com sucesso'
    else
      flash[:alert] = 'Não foi possível editar dados do buffet.'
      render 'edit'
    end
  end

  def search
    @query = params['query']
    first_condition = ['brand_name LIKE ? or city LIKE ?', "%#{@query}%", "%#{@query}%"]
    second_condition = ['events.name LIKE ?', "%#{@query}%"]

    first_sql = Venue.active.where(first_condition).to_sql
    second_sql = Venue.active.joins(:events).where(second_condition).distinct.to_sql

    @venues = Venue.from("(#{first_sql} UNION #{second_sql}) AS venues")
    @venues = @venues.order(:brand_name) if @venues.count > 1
  end

  def active
    @venue.active!
    redirect_to @venue
  end

  def inactive
    @venue.inactive!
    redirect_to @venue
  end

  private

  def venue_params
    params.require(:venue).permit(:brand_name, :corporate_name, :registration_number,
                                  :address, :district, :city, :state, :zip_code,
                                  :email, :phone_number, :description, :payment_methods,
                                  :photo)
  end

  def set_and_check_user
    @venue = Venue.find(params[:id])

    return unless user_signed_in? && @venue.user != current_user

    redirect_to venue_path(current_user.venue.id), alert: 'Acesso não permitido!'
  end
end
