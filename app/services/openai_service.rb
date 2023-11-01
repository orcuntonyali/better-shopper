require 'openai'
require 'json'

class OpenaiService
  def self.client
    @client ||= OpenAI::Client.new
  end

  # process_audio
  def self.transcribe(audio_input)
    response = client.audio.transcribe(
      parameters: {
        model: "whisper-1",
        file: File.open(audio_input, "rb")
      }
    )
    response["text"]
  end

  # process_order
  def self.process_order(order_input)
    api_payload_messages = build_api_payload_messages(order_input)
    Rails.logger.debug "Order_input: #{order_input.inspect}"
    api_response = call_openai_api(api_payload_messages)
    Rails.logger.debug "API response: #{api_response.inspect}"
    structured_response = api_response["choices"][0]["message"]["content"] if api_response["choices"]
    Rails.logger.debug "Structured response: #{structured_response.inspect}"
    parse_cart_items(structured_response) || { error: 'Unexpected response' }
    # Structured response: "{"cart_items\":
    # [{\"name\": \"potato\", \"quantity\": 2},
    # {\"name\": \"tomato\", \"quantity\": 1},
    # {\"name\": \"onion\", \"quantity\": 1}]
    # }"
  end

  def self.parse_cart_items(structured_response)
    parsed_response = structured_response.is_a?(String) ? JSON.parse(structured_response) : structured_response
    parsed_response&.dig("cart_items")
  end

  # Below is private methods
  def self.build_api_payload_messages(order_input)
    [{ role: "system", content: prompt_details }, { role: "user", content: order_input }]
  end

  def self.call_openai_api(api_payload_messages)
    parameters = {
      model: "gpt-4-0613",
      messages: api_payload_messages,
      temperature: 0,
      max_tokens: 512
    }
    # OpenAI::Client.new.chat(parameters:)
    client.chat(parameters:)
  rescue StandardError => e
    { error: e.message }
  end

  def self.prompt_details
    <<-HEREDOC
      1 Listen to filter the item and quantity information from a grocery order
      2 Translate all input to American English and then process
      3 Create a JSON response only similar to:
        {
          "cart_items": [
            {"name": "apple", "quantity": 2},
            {"name": "banana", "quantity": 6},
            {"name": "milk", "quantity": 1}
          ]
        }
      3.1 with no duplicates names
      3.2 with name value always singular American English word and 2 words max
      3.3 with Quantity is a positive integer and equal to 1 if not specified
      4 If it's an empty JSON response, return an error message
    HEREDOC
  end

  private_class_method :prompt_details, :build_api_payload_messages, :call_openai_api
end
