module Anthropic
  struct Error
    include JSON::Serializable

    property message : String
    property type : String
  end

  struct ErrorResponse
    include JSON::Serializable

    property type : String
    property error : Error
  end
end
