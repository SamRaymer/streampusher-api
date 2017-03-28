require 'rails_helper'
require 'webmock/rspec'
require 'sidekiq/testing'

describe CheckRadioIsUp do
  before do
    Sidekiq::Testing.inline!
  end
  it "sends alert emails if the radio is down" do
    radio = FactoryGirl.create :radio, name: "garf_radio"
    url = radio.icecast_json
    stub_request(:any, url).
      to_return(body: File.read("spec/fixtures/icecast_json.json"))
    CheckRadioIsUp.new.perform
    expect(ActionMailer::Base.deliveries.last.subject).to eq "Radio garf_radio is not reachable"
  end

  it "doesn't alert emails if the radio is up" do
    radio = FactoryGirl.create :radio, name: "datafruits"
    url = radio.icecast_json
    stub_request(:any, url).
      to_return(body: File.read("spec/fixtures/icecast_json.json"))
    CheckRadioIsUp.new.perform
    expect(ActionMailer::Base.deliveries.last.try(:subject)).not_to eq "Radio datafruits is not reachable"
  end
end
