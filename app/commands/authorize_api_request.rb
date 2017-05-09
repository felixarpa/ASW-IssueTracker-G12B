class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  def http_api_key_header
    return headers['X-API-Key'] if headers['X-API-Key'].present?
    errors.add(:unauthorized, 'Missing authentication or API key')
    nil
  end

  def user
    if http_api_key_header
      @user ||= User.find_by(api_key: http_api_key_header)
      @user || errors.add(:unauthorized, 'Invalid API key') && nil
    end
  end
end