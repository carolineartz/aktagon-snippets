require_relative '../spec_helper'
require_relative '../../app'

describe Language do
  include Rack::Test::Methods
  let(:language) { FactoryGirl.create :language } 

  it "creates item" do
    expect(language.name).to eq "html"
  end

end
