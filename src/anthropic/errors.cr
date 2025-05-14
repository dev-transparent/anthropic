module Anthropic
  class RequestError < Exception
    getter response : ErrorResponse

    def initialize(@response : ErrorResponse)
      super(@response.error.message)
    end
  end
end
