class TestEmailJob
  include Backburner::Queue
  include Loggy
  queue "emails"  # defaults to 'backburner-jobs' tube
  queue_priority 1000 # most urgent priority is 0
  queue_respond_timeout 100 # number of seconds before job times out

  def self.perform(hash)
    TestMailer.test_email(hash['email'], subject: hash['subject']).deliver
    1
  rescue Exception => e
    0
  end
end