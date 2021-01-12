require 'byebug'
require 'rspec'
require 'rspec/mocks'

require_relative '../courier/blue-express'
require_relative '../lib/blue-express-client'

describe BlueExpress do
  let(:credentials) {
    { api_key: 'aa123' }
  }

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

  # Mocking blue express client
  let(:blue_express_client) do
    blue_express_client_instance = instance_double(BlueExpressClient)
    allow(BlueExpressClient)
      .to receive(:new)
      .and_return(blue_express_client_instance)

    blue_express_client_instance
  end

  let(:subject) { described_class.new(credentials) }

  describe '#is_address_valid?' do
    context 'if request fails ' do
      it 'raises Courier::RequestError' do

        allow(blue_express_client)
          .to receive(:address_valid?)
          .and_return({ error: :invalid_request })

        expect { subject.is_address_valid?(destination) }.to raise_error(BlueExpress::RequestError)
      end
    end

    context 'if request works, but we get an unknown response' do
      it 'raises Courier::InvalidResponse' do

        allow(blue_express_client)
          .to receive(:address_valid?)
          .and_return({error: :invalid_response})

        expect { subject.is_address_valid?(destination) }.to raise_error(BlueExpress::InvalidResponse)
      end
    end

    context 'if request works, and we get a valid response' do
      it 'returns false if address is invalid' do

        allow(blue_express_client)
          .to receive(:address_valid?)
          .and_return({ result: false })

        res = subject.is_address_valid?(destination)

        expect(res).to be false
      end
      it 'returns true if address is valid' do

        allow(blue_express_client)
          .to receive(:address_valid?)
          .and_return({ result: true })

        res = subject.is_address_valid?(destination)
        expect(res).to be true
      end
    end
  end

  describe '#fetch_label' do

    let(:tracking_code) { '123456789' }

    context 'if request fails (eg ECONNRESET)' do
      it 'raises Courier::RequestError' do
        allow(blue_express_client)
          .to receive(:fetch_label)
          .and_return({ error: :invalid_request })

        expect { subject.fetch_label(tracking_code) }.to raise_error(BlueExpress::RequestError)
      end
    end

    context 'if request works, but we get an unknown response' do
      it 'raises Courier::InvalidResponse' do

        allow(blue_express_client)
          .to receive(:fetch_label)
          .and_return({ error: :invalid_response })

        expect { subject.fetch_label(tracking_code) }.to raise_error(BlueExpress::InvalidResponse)
      end
    end

    context 'if request works, but the shipment/tracking ID is invalid' do
      it 'raises Courier::ShipmentNotFound' do
       
        allow(blue_express_client)
          .to receive(:fetch_label)
          .and_return({ error: :invalid_tracking_id })

        expect { subject.fetch_label(tracking_code) }.to raise_error(BlueExpress::ShipmentNotFound)
      end
    end
  end
end
