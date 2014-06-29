class UserMailbox

  def self.mailbox_name(s)
    s.match(/sent/i) ? 'sentbox' : s
  end
end