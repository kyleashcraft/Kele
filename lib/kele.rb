require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: { email: email, password: password })
    @auth_token = post_response['auth_token']
    if !@auth_token
      p "Incorrect credentials, please try again!"
    end
  end

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(pg = 0)
    pg > 0 ? url = "/message_threads?page=#{pg}" : url = "/message_threads"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    @messages = JSON.parse(response.body)
  end

  def send_message(sender, recipient_id, subject, body)
    self.class.post("/messages", body: {sender: sender, recipient_id: recipient_id, subject: subject, "stripped-text": body})
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment)
    enrollment_id = self.get_me['current_enrollment']['id']
    self.class.post("/checkpoint_submissions",
      body: { assignment_branch: assignment_branch,
              assignment_commit_link: assignment_commit_link,
              checkpoint_id: checkpoint_id,
              comment: comment,
              enrollment_id: enrollment_id
            },
      headers: { "authorization" => @auth_token }
    )
  end
end
