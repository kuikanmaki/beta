require 'spec_helper'

describe "books/new" do
  before(:each) do
    assign(:book, stub_model(Book,
      :name => "MyString",
      :slug => "MyString",
      :author => "MyString",
      :link => "MyString",
      :page => nil,
      :interest => nil
    ).as_new_record)
  end

  it "renders new book form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => books_path, :method => "post" do
      assert_select "input#book_name", :name => "book[name]"
      assert_select "input#book_slug", :name => "book[slug]"
      assert_select "input#book_author", :name => "book[author]"
      assert_select "input#book_link", :name => "book[link]"
      assert_select "input#book_page", :name => "book[page]"
      assert_select "input#book_interest", :name => "book[interest]"
    end
  end
end
