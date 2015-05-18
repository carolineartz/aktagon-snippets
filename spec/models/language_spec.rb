require_relative '../spec_helper'
require_relative '../../app'

describe Language do
  include Rack::Test::Methods
  
  before(:all) do
    Language.delete_all
  end

  let(:language) { FactoryGirl.create :language } 

  it "creates language" do
    expect(language.name).to eq "html"
  end

end
