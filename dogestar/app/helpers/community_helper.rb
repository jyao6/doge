module CommunityHelper
  COMMUNITIES = { "Harvard University"=> {timezone: "Eastern Time (US & Canada)"}}

  #TODO: unhardcode this
  def current_community
    "Harvard University"
  end

  def current_tz_region
  	COMMUNITIES[current_community][:timezone]
  end

  def current_timezone
    Time.find_zone(current_tz_region)
  end

  def utc2current(utc_time)
    utc_time.in_time_zone(current_tz_region)
  end

end