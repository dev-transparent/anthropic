module Anthropic
  struct TextContentBlock
    include JSON::Serializable

    property type : String = "text"
    property text : String

    def initialize(@text)
    end
  end

  alias ContentBlock = TextContentBlock

  struct Message
    include JSON::Serializable

    property role : String
    property content : String | Array(ContentBlock)

    def initialize(@role, @content)
    end
  end

  struct ServerToolUse
    include JSON::Serializable

    property web_search_requests : Int32
  end

  struct Usage
    include JSON::Serializable

    property cache_creation_input_tokens : Int32?
    property cache_read_input_tokens : Int32?
    property input_tokens : Int32
    property output_tokens : Int32
    property server_tool_use : ServerToolUse?
  end

  struct Messages
    include JSON::Serializable

    property id : String
    property model : String
    property role : String
    property stop_reason : String?
    property stop_sequence : String?
    property type : String
    property usage : Usage
    property content : Array(ContentBlock)


    def self.create(model : String, max_tokens : Int32, messages : Array(Message), system : String? = nil, temperature : Float32? = nil)
      response = Anthropic.pool.checkout do |client|
        client.post(
          path: "/v1/messages",
          body: {
            "model" => model,
            "max_tokens" => max_tokens,
            "messages" => messages,
            "system" => system,
            "temperature" => temperature
          }.to_json
        )
      end

      case response.status
      when .ok?
        Messages.from_json(response.body)
      else
        pp response.body
        raise RequestError.new(ErrorResponse.from_json(response.body))
      end
    end
  end
end
