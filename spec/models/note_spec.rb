require 'spec_helper'

describe Note do

  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is not idiomatically correct.
    @note = Note.new(content: "Lorem ipsum", user_id: user.id)
  end

  subject { @note }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
end