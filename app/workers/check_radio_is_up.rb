class CheckRadioIsUp < ActiveJob::Base
  queue_as :default

  def perform
    Radio.enabled.find_each do |radio|
      url = radio.icecast_panel_url
      res = Net::HTTP.get_response(URI(radio.icecast_json))
      json = JSON.parse(res.body)
      server = json.dig("icestats", "source").find{|s| s["server_name"] == "#{radio.name}.mp3"}
      if server
        puts "radio is up"
      else
        AdminMailer.radio_not_reachable(radio).deliver_later
      end
    end
  end
end
