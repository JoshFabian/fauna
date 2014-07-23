Fabricator(:post) do
  body { sequence(:body) { |i| "post body #{i}" } }
end