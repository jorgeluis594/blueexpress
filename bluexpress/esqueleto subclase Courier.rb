class ExampleCourier < Courier
  def initialize(credentials)
    @credentials = credentials
  end

  def is_address_valid?(address)
    # si lo soporta el courier
  end

  def fetch_label(tracking_code)
    # si lo soporta el courier
  end

  def get_rates(package, origin, destination)
    # si lo soporta el courier
  end

  def request_shipment(params)
    # siempre
  end

  def track_shipment(tracking_code)
    # si lo soporta el courier
  end

  private

  # ... 
end