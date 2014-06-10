include Paddock

Paddock(Rails.env) do
  enable :user_messaging,  :in => [:development, :test]
end