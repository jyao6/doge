module CommunityHelper
  COMMUNITIES = { "Harvard University"=> {timezone: "Eastern Time (US & Canada)"}}

  #TODO: unhardcode this
  def current_community
    "Harvard University"
  end

  def current_timezone
    Time.find_zone(COMMUNITIES[current_community][:timezone])
  end

end