require 'httparty'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: { email: email, password: password } )
    @auth_token = post_response['auth_token']
    if !@auth_token
      p "Incorrect credentials, please try again!"
    end
  end

end
