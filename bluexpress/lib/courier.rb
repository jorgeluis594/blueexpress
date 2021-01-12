class Courier
  class UnsupportedMethod < ArgumentError; end
  class RequestError < StandardError; end
  class InvalidCredentials < RequestError; end
  class ShipmentNotFound < RequestError; end
  class InvalidResponse < StandardError; end
end