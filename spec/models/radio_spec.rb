require 'rails_helper'

RSpec.describe Radio, :type => :model do
  let(:dj){ FactoryGirl.create :user }
  it "knows its default playlist redis key" do
    radio = FactoryGirl.create :radio
  end

  it "spaces aren't allowed in the name" do
    radio = FactoryGirl.build :radio, name: "pizza party"
    expect(radio.valid?).to eq false
    expect(radio.errors[:name]).to be_present
  end

  it "creates a default playlist" do
    radio = FactoryGirl.create :radio
    expect(radio.playlists.first.name).to eq "default"
    expect(radio.default_playlist_id).to eq radio.playlists.first.id
  end

  it "tells you the currently scheduled show" do
    radio = FactoryGirl.create :radio
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    scheduled_show_1 = FactoryGirl.create :scheduled_show, playlist: playlist_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")
    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      expect(radio.current_scheduled_show).to eq scheduled_show_1
    end
  end

  it "tells you the next scheduled show" do
    radio = FactoryGirl.create :radio
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    PersistPlaylistToRedis.perform playlist_1

    playlist_2 = FactoryGirl.create :playlist, name: "my_playlist_2", radio: radio
    PersistPlaylistToRedis.perform playlist_2

    scheduled_show_1 = FactoryGirl.create :scheduled_show, playlist: playlist_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    scheduled_show_2 = FactoryGirl.create :scheduled_show, playlist: playlist_2, radio: radio,
      start_at: Chronic.parse("January 1st 2092 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2092 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      expect(radio.current_scheduled_show).to eq scheduled_show_1
      expect(radio.next_scheduled_show).to eq scheduled_show_2
    end
  end
end
