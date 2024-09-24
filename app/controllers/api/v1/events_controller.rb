class Api::V1::EventsController < Api::V1::ApiController
  before_action :set_event, only: %i[show availability]

  def index
    venue = Venue.find(params[:venue_id])
    render status: :ok, json: venue.events.as_json(except: %i[created_at updated_at])
  end

  def show
    render status: :ok, json: @event.as_json(except: %i[created_at updated_at])
  end

  def availability
    message = 'O número de convidados excede a capacidade máxima do buffet para este evento.'
    return render status: :ok, json: { message: message } if number_of_guests > @event.maximum_guests_number

    message = 'O buffet já está reservado para a data escolhida.'
    return render status: :ok, json: { message: message } if date_unavailable?(event_date)

    base_price = calculate_base_price(event_date)
    extra_fee = calculate_extra_fee(number_of_guests, event_date)

    render status: :ok, json: { preço_base: base_price,
                                taxa_adicional: extra_fee,
                                valor_final_estimado: base_price + extra_fee }
  end

  private

  def set_event
    @venue = Venue.find(params[:venue_id])
    @event = @venue.events.find(params[:id])
  end

  def calculate_base_price(date)
    return @event.price.weekday_base_price if date.to_date.on_weekday?

    @event.price.weekend_base_price
  end

  def calculate_extra_fee(number_of_guests, event_date)
    return 0 if number_of_guests <= @event.minimum_guests_number

    difference = number_of_guests - @event.minimum_guests_number
    return difference * @event.price.weekday_plus_per_person if event_date.to_date.on_weekday?

    difference * @event.price.weekend_plus_per_person
  end

  def date_unavailable?(date)
    @venue.orders.confirmed.where(event_date: date).any?
  end

  def event_date
    params[:date]
  end

  def number_of_guests
    params[:guests].to_i
  end
end
