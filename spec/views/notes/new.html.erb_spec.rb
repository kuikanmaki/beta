require 'spec_helper'

describe "notes/new" do
  before(:each) do
    assign(:note, stub_model(Note,
      :content => "MyString",
      :user_id => 1,
      :page => nil
    ).as_new_record)
  end

  it "renders new note form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notes_path, :method => "post" do
      assert_select "input#note_content", :name => "note[content]"
      assert_select "input#note_user_id", :name => "note[user_id]"
      assert_select "input#note_page", :name => "note[page]"
    end
  end
end
