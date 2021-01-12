require_relative 'request'

class BlueExpressLocation
  def initialize(credentials)
    @credentials = credentials
    @request = XMLRequest.new(@credentials)
  end

  def get_region_code(region)
    regions = @request.query(:get_regions, {codigo_pais: 'CL'})
    regions.find { |region| region[:nombre].downcase == region.downcase }[:codigo]
  end

  def get_locality_code(region_code, locality)
    localities = @request.query(:get_localities, {})
  end
end