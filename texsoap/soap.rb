require 'savon'
url = 'https://portal.bluex.cl/ws_tarifa_cliente/TarifaClienteWSServiceImpl?wsdl'
client = Savon.client({
  wsdl: url,
  env_namespace: :soapenv,
  log: true,
  log_level: :debug,
  pretty_print_xml: true,
  env_namespace: :soapenv,
  namespaces: {'xmlns:soapenv' => "http://schemas.xmlsoap.org/soap/envelope/", 'xmlns:ser' => "http://service.cliente.tarifa.bluex.cl/" },
  namespace_identifier: :ser,
  soap_header: { 'ser:cabecera' =>{token: '28a0df782c09098abe6afc44dc736eec', codigoUsuario: '14355'} }
})
resp = client.call(:obtener_tarifa, message: { 
  obtieneTarifa: {
    RequestObtieneTarifa: {
      datosCliente: {
        codigoPais: 'CL',
        codigoEmpresa: 2000,
        cuentaCorriente: '96801150-1-8'
      },
      datosEnvio: {
        tipoServicio: 'EX',
        fechaCreacion: '',
        origen: {
          region: 13,
          localidad: 'SANTIAGO',
        },
        destino: {
          region: 5,
          localidad: 'VIÑA DEL MAR'
        }
      },
      datosProducto: {
        producto: 'P',
        familiaProducto: 'PAQU',
        largo: 2.5,
        ancho: 1.0,
        alto: 1.0,
        pesoFisico: 13.5
      },
      otrosServicio: {
        listaServComplementario: '',
        delimitador: ''
      }
    }
  }
 })
