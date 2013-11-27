require 'spec_helper'

describe "books/show" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :name => "Name",
      :slug => "Slug",
      :author => "Author",
      :link => "Link",
      :page => nil,
      :interest => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Slug/)
    rendered.should match(/Author/)
    rendered.should match(/Link/)
    rendered.should match(//)
    rendered.should match(//)
  end
end
