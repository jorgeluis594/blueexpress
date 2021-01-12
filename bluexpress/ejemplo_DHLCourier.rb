require 'forwardable'
require_relative './dhl/client'

class DhlCourier < Courier
  extend Forwardable

  def is_address_valid?(address)
    true
  end

  def get_rates(package, origin, dest)
    weight = (package[:height].to_i * package[:width].to_i * package[:length].to_i) / 5000.0
    client.get_rates(weight, origin[:locality_name], dest[:locality_name])
  end

  def fetch_label(tracking_code)
    raise UnsupportedMethod
  end

  def_instance_delegators :client, :track_shipment, :request_shipment

  private

  def client
    @client ||= DHL::Client.new(@credentials)
  end

end
