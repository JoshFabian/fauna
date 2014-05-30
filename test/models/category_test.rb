require "test_helper"

describe Category do
  describe "create" do
    describe "root nodes" do
      it "should create with level 1" do
        @category = Category.create!(name: 'Root')
        @category.parent.must_equal nil
        @category.level.must_equal 1
      end

      it "should create with increasing positions" do
        @root1 = Category.create!(name: 'Root 1')
        @root1.position.must_equal 1
        @root2 = Category.create!(name: 'Root 2')
        @root2.position.must_equal 2
      end
    end

    describe "child nodes" do
      before do
        @root = Category.create!(name: 'Root')
      end

      it "should create with root parent" do
        @child = @root.children.create(name: "child")
        @child.parent.must_equal @root
        @child.level.must_equal 2
        @root.reload
        @root.children.must_equal [@child]
        @root.children_count.must_equal 1
      end

      it "should create with increasing positions" do
        @child1 = @root.children.create(name: "child 1")
        @child1.position.must_equal 1
        @child2 = @root.children.create(name: "child 2")
        @child2.position.must_equal 2
      end
    end
  end

  describe "listings" do
    before do
      @user = Fabricate(:user)
      @listing = Fabricate(:listing, user: @user)
    end

    it "should attach category object to listing" do
      @lizards = Category.create!(name: 'Lizards')
      @listing.categories.push(@lizards)
      @listing.reload
      @listing.categories.collect(&:name).must_equal ['Lizards']
      @listing.category_names.must_equal ['lizards']
    end

    it "should attach category and subcategory objects to listing" do
      @lizards = Category.create!(name: 'Lizards')
      @geckos = @lizards.children.create!(name: 'Geckos')
      @listing.categories.push(@lizards)
      @listing.categories.push(@geckos)
      @listing.reload
      @listing.categories.collect(&:name).must_equal ['Lizards', 'Geckos']
      @listing.category_names.must_equal ['lizards', 'geckos']
    end
  end
end