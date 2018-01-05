require 'httparty'
require 'json'

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

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(id)
    response = self.class.get("/mentors/#{id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

end
