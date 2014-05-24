Fabricator(:listing) do
  title { sequence(:title) { |i| "Title #{i}" } }
  price {1000}
end