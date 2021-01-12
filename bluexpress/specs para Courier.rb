describe ExampleCourier do

  let(:credentials) {
    { api_key: 'aa123' }
  }

  let(:subject) { described_class.new(credentials) }

  let(:package) {
    {
      type: 'box',
      weight: 500,
      width: 10,
      length: 10,
      height: 10
    }
  }

  let(:origin) {
    {
      street: 'Mar del Plata 2111',
      street_2: 'Depto 201',
      locality_name: 'Providencia',
      region_name: 'Región Metropolitana',
      country_name: 'Chile'
    }
  }

  let(:destination) {
    {
      street: 'General Lagos 1662',
      street_2: '',
      locality_name: 'Valdivia',
      region_name: 'Región de los Ríos',
      country_name: 'Chile'
    }
  }

  describe '#is_address_valid?' do

    # option 1: que el courier no permita validar direcciones
    it 'returns true' do
      # ...
    end

    # opcion 2: que el courier permita validar direcciones
    context 'if request fails (eg ECONNRESET)' do
      it 'raises Courier::RequestError' do
        # ...
      end
    end

    context 'if request works, but we get an unknown response' do
      it 'raises Courier::InvalidResponse' do
        # ...
      end
    end

    context 'if request works, and we get a valid response' do
      it 'returns false if address is invalid' do
        # ...
        res = subject.is_address_valid?(invalid_address)
        expect(res).to be_false
      end
      it 'returns true if address is valid' do
        # ...
        res = subject.is_address_valid?(valid_address)
        expect(res).to be_true
      end
    end

  end

  describe '#fetch_label' do

    let(:tracking_code) { '123456789' }

    # opcion 2: que el courier sí permita rescatar etiquetas
    context 'if request fails (eg ECONNRESET)' do
      it 'raises Courier::RequestError' do
        # ...
      end
    end

    context 'if request works, but we get an unknown response' do
      it 'raises Courier::InvalidResponse' do
        # ...
      end
    end

    context 'if request works, but the shipment/tracking ID is invalid' do
      it 'raises Courier::ShipmentNotFound' do
        # ...
      end
    end

    context 'if request works, and we get a valid response' do
      it 'return an array containing label data and type' do
        # ...
        data, type = subject.fetch_label(tracking_code)
        expect(data).to be_a(String)
        expect(data[1..3]).to eq("PNG")
        expect(type).to eq('png')
      end
    end

  end

  describe '#get_rates' do

    # opcion 1: que el courier no permita obtener costos de envío
    it 'raises Courier::UnsupportedMethod' do
      # ...
    end

    # opcion 2: que el courier sí permita obtener costos de envío
    context 'if request fails (eg ECONNRESET)' do
      it 'raises Courier::RequestError' do
        # ...
      end
    end

    context 'if request works but credentials arent valid' do
      it 'raises Courier::InvalidCredentials' do
        # ...
      end
    end

    context 'if request works, but we get an unknown response' do
      it 'raises Courier::InvalidResponse' do
        # ...
      end
    end

    context 'if request works, and we get a valid response' do
      it 'return a hash containing costs data (desc => cost)' do
        # ...
        res = subject.get_rates(package, origin, destination)
        expect(res).to eq({
         "2 - OVERNIGHT" => "10549.00",
         "3 - DIA HABIL SIGUIENTE" => "7033.00",
        })
      end
    end

  end

  describe '#request_shipment' do

    let(:params) {
      {
        method: 'xx',
        package: package,
        num_pieces: 1,
        delivery_requested_at: nil,
        delivery_requested_until: nil,
        origin: origin,
        destination: destination,
        sender: {
          name: 'COMERCIAL TEST S.A.',
          email: 'WEB@TEST.CL',
          phone: '223344556'
        },
        recipient: {
          name: 'Jose Juan Izquierdo Irarrazaval',
          email: 'josejuanizquierdo@gmail.com',
          phone: '992079261'
        },
        order_code: 'ABC123',
        ref: 'Una descripcion',
        value: 20000,
        currency: 'CLP',
        items: [{ quantity: 2, unit_price: 10000, name: 'An item' }]
      }
    }

    context 'if request fails (eg ECONNRESET)' do
      it 'raises Courier::RequestError' do
        # ...
      end
    end

    context 'if request works but credentials arent valid' do
      it 'raises Courier::InvalidCredentials' do
        # ...
      end
    end

    context 'if request works, but params are invalid' do
      it 'returns hash containing error message' do
        # ...
      end
    end

    context 'if request works, and we get a valid response' do
      it 'return a hash containing tracking and label data' do
        # ...
        res = subject.request_shipment(params)
        expect(res[:tracking_code]).to match(/\d{9}/)
        expect(res[:label_image]).to be_a(String)
        expect(res[:label_image][1..3]).to eq("PNG")
        expect(res[:label_type]).to eq('png')
      end
    end

  end

  describe '#track_shipment' do

    let(:tracking_code) { '1234567890' }

    context 'if request fails (eg ECONNRESET)' do
      it 'raises Courier::RequestError' do
        # ...
      end
    end

    context 'if request works but credentials arent valid' do
      it 'raises Courier::InvalidCredentials' do
        # ...
      end
    end

    context 'if request works, but params are invalid' do
      it 'returns hash containing error message' do
        # ...
      end
    end

    context 'if request works, and we get a valid response' do
      it 'return an array containing tracking events' do
        # ...
        res = subject.track_shipment(tracking_code)
        expect(res).to be_a(Array)
        res.first.tap do |event|
          expect(event[:time]).to be_a(Time)
          expect(event[:description]).to be_a(String)
        end
      end
    end
  end

end