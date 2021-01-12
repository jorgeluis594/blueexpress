require_relative '../lib/blue-express-client'
require_relative '../lib/courier'

class BlueExpress < Courier
  def initialize(credentials)
    @credentials = credentials
  end

  def is_address_valid?(address)
    true
  end

  def fetch_label(tracking_code)
    raise UnsupportedMethod
  end

  def get_rates(package, origin, destination)
    client.ger_rates(package, origin, destination)
  end

  private

  def client
    @client ||= BlueExpressClient.new(@credentials)
  end

  def handler_error(error)
    case error
    when :invalid_request
      raise RequestError
    when :invalid_response
      raise InvalidResponse
    when :invalid_tracking_id
      raise ShipmentNotFound
    else
      raise ArgumentError
    end
  end

end
