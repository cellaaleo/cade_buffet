class Api::V1::EventsController < Api::V1::ApiController
  def index
    venue = Venue.find(params[:venue_id])
    events = venue.events
    render status: 200, json: events.as_json(except: [:created_at, :updated_at])
  end

  def show
    venue = Venue.find(params[:venue_id])
    event = venue.events.find(params[:id])
    render status: 200, json: event.as_json(except: [:created_at, :updated_at])
  end

  def availability
    venue = Venue.find(params[:venue_id])
    event = venue.events.find(params[:id])
    number_of_guests = params[:guests].to_i

    if number_of_guests > event.maximum_guests_number
      return render status: 422, json: { error: "O número de convidados excede a capacidade máxima do buffet para este evento." }
    end

    orders = venue.orders.where("event_date = ?", params[:date])

    orders.each do |order|
      if order.status == "confirmed"
        return render status: 500, json: { error: "O buffet já está reservado para a data escolhida." }
      end
    end
    
    date = params[:date]
    date = date.to_date
    base_price = event.price.weekday_base_price if date.on_weekday?
    base_price = event.price.weekend_base_price if date.on_weekend?

    extra_fee = 0
    if number_of_guests > event.minimum_guests_number
      if date.on_weekday?
        extra_fee = (number_of_guests - event.minimum_guests_number) * event.price.weekday_plus_per_person
      else
        extra_fee = (number_of_guests - event.minimum_guests_number) * event.price.weekend_plus_per_person
      end
    end

    render status: 200, json: {preço_base: base_price,
                               taxa_adicional: extra_fee,
                               valor_final_estimado: base_price + extra_fee}
  end

end