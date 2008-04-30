module ApplicationHelper
  
  # Show the local time
  def tz(time_at)
    if logged_in? && !current_user.time_zone.nil?
      TzTime.zone = current_user.tz
    else
      TzTime.zone = TZInfo::Timezone.new('America/Chicago')
    end
    TzTime.zone.nil? ? time_at : TzTime.zone.utc_to_local(time_at.utc)
  end
 
  def local_time(time_at)
    # yields a date displayed like "6/8/07 4:51pm" in the user's local time zone
    if logged_in? && !current_user.time_zone.nil?
      tz(time_at).strftime("*%m/*%d/%y *%I:%M%p").gsub('*0', '').gsub('*', '').downcase
    else
       tz(time_at).strftime("*%m/*%d/%y *%I:%M%p").gsub('*0', '').gsub('*', '').downcase + 
         " CT"
    end
  end
 
  def local_date(time_at)
    # yields a date displayed like "6/8/07" in the user's local time zone
    if logged_in? && !current_user.time_zone.nil?
      tz(time_at).strftime("*%m/*%d/%y").gsub('*0', '').gsub('*', '').downcase
    else
       tz(time_at).strftime("*%m/*%d/%y").gsub('*0', '').gsub('*', '').downcase + 
         " CT"
    end
  end
  
  def zoneless_time(time_at)
    # yields a date displayed like "6/8/07 4:51pm" without converting to a local time zone
    time_at.strftime("*%m/*%d/%y *%I:%M%p").gsub('*0', '').gsub('*', '').downcase
  end
    
  # added for use with User and Organization
  def phonable_path(phonable)
    if phonable.kind_of? User
        user_path(phonable)
      else
        organization_path(phonable)
      end
  end 
  
  # added for use with User and Organization  
  def addressable_path(addressable)
    if addressable.kind_of? User
        user_path(addressable)
      else
        organization_path(addressable)
      end
  end
  
  # creates a link with a "highlighted" class if it's the current page
  def highlight_current_link_to(title, url, options={})
    options[:id] = "current" if current_page?(url)
    link_to title, url, options
  end
  
  # insetad of trancating midword, this will truncate at word boundaries
  def truncate_by_word(sentence)
  wordcount = 5
  sentence.split([0..(wordcount-1)].join(" ") + (sentence.split.size > wordcount ? "..." : ""))
  end
  
end
