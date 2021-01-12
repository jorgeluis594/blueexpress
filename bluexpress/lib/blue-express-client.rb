require_relative 'request'
require_relative 'blue-express-location'

class BlueExpressClient
  DELIVERY_METHODS = {
    'EX' => 'Express',
    'PY' => 'Priority',
    'PR' => 'Premium'
  }.freeze

  def initialize(credentials)
    @credentials = credentials
    @request = XMLRequest.new(credentials)
  end

  def ger_rates(package, origin, destination)
    package_data = { package: package, origin: origin, destination: destination }
    DELIVERY_METHODS.map do |method_code, method_description|
      [method_description, @request.query(:get_rates, parse_data_pricing(package_data, method_code))]
    end.to_h
  end

  def emission()

  end

  private

  def parse_data_pricing(package_data, type)
    {
      datos_cliente: {
        codigo_pais: 'CL',
          codigo_empresa: 2000,
      },
      datos_envio: {
        tipo_servicio: type,
        fecha_creacion: nil,
        origen: {
          region: package_data[:origin][:region_name],
           localidad: package_data[:origin][:locality_name]
        },
        destino: {
          region: package_data[:destination][:region_name],
          localidad: package_data[:destination][:locality_name]
        }
      },
      datos_producto: {
        producto: package_data[:package][:type],
        familia_producto: package_data[:package][:type],
        largo: package_data[:package][:length],
        ancho: package_data[:package][:with],
        alto: package_data[:package][:height],
        peso_fisico: package_data[:package][:weight]/1000
      },
      otros_servicio: {
        lista_serv_complementario: nil,
        delimitador: nil,
      }
    }
  end
end