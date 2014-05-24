require "test_helper"

describe Category do
  describe "create" do
    it "should create root node" do
      @category = Category.create!(name: 'Root')
      @category.parent.must_equal nil
      @category.level.must_equal 1
    end

    it "should create child node" do
      @root = Category.create!(name: 'Root')
      @child = @root.children.create(name: "child")
      @child.parent.must_equal @root
      @child.level.must_equal 2
      @root.reload
      @root.children.must_equal [@child]
      @root.children_count.must_equal 1
    end
  end

  describe "listings" do
    before do
      @lizards = Category.create!(name: 'Lizards')
      @user = Fabricate(:user)
      @listing = Fabricate(:listing, user: @user)
    end

    it "should attach category object to listing" do
      @listing.categories.push(@lizards)
      @listing.categories.collect(&:name).must_equal ['Lizards']
    end
  end
end