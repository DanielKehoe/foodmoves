class ActiveRecord::Base
  
  # derived from example at 
  # http://www.iamstillalive.net/notes/2007/04/has_many_through_with_has_many_polymorphs
  def phone_ids= phone_ids
    phone_ids.map!(&:to_i)
    phones.delete phones.reject{|phone| phone_ids.include? phone.id}
    phones << Phone.find(phone_ids - phones.map(&:id))
  end  
end