require 'savon'

class XMLRequest
  def initialize(credentials)
    @token = credentials[:api_token]
    @user_code = credentials[:user_code]
  end

  def query(method, body)
    case method
    when :get_rates
      return get_rates(body)
    else
      raise ArgumentError
    end
  end

  private

  def execute(request_data, header, body)
    client = Savon.client({
      wsdl: request_data[:url],
      env_namespace: :soapenv,
      namespaces: {'xmlns:soapenv' => "http://schemas.xmlsoap.org/soap/envelope/", 'xmlns:ws' => "http://ws.bluex.cl/" },
      namespace_identifier: :ws,
      soap_header: { 'ws:requestHeader' => header}
    }).call(request_data[:method], message_tag:'obtenerTarifa', request_data[:message_tag], message: body)
  end

  def get_rates(body)
    header = { token: @token, codigo_usuario: @user_code }
    request_data = {
      url: 'https://portal.bluex.cl/ws_tarifa_cliente/TarifaClienteWSServiceImpl?wsdl',
      method: :obtener_tarifa,
      message_tag: 
    }
    execute(
        header,
        body
    )
  end
end