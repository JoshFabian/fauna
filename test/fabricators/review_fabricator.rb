Fabricator(:review) do
  body { sequence(:body) { |i| "review body #{i}" } }
end