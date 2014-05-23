Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password {'x'}
  password_confirmation {'x'}
end