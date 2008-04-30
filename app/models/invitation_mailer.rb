class InvitationMailer < ActionMailer::ARMailer
  @@bcc = 'archive@foodmoves.com'
  @@from = 'Foodmoves Support <support@foodmoves.com>'

  def signup(guest)
    @subject    = 'Welcome to Foodmoves'
    @body["guest"] = guest
    @recipients = guest.email
    @bcc        = @@bcc
    @from       = @@from
    @sent_on    = Time.now
  end
  
  def invite(guest, message, current_user)
    @subject    = "An Invitation from #{current_user.name}"
    @body       = {:guest => guest,
                :message => message,
                :current_user => current_user}
    @recipients = guest.email
    @bcc        = @@bcc
    @from       = @@from
    @sent_on    = Time.now
    @content_type    = "text/html"
  end

  def new_buyer_invite(guest, watched_item, current_user)
    @subject    = "Welcome to Foodmoves Buyers Alerts"
    @body       = {:guest => guest,
                :watched_item => watched_item,
                :current_user => current_user}
    @recipients = guest.email
    @bcc        = @@bcc
    @from       = @@from
    @sent_on    = Time.now
    @content_type    = "text/html"
  end
  
  # sent when a user is setting up trading with an affiliation to a company
  def affiliation(current_user, company)
    @subject    = "#{current_user.name} wants to trade at Foodmoves.com"
    @body       = {:current_user => current_user,
                :company => company}
    @recipients = current_user.email
    @bcc        = @@bcc
    @from       = @@from
    @sent_on    = Time.now
  end
 
  # sent when an administrator verifies a user's affiliation to a company  
  def approval(user, company)
    @subject    = "#{user.name} is authorized to trade at Foodmoves.com"
    @body       = {:user => user,
                :company => company}
    @recipients = user.email
    @bcc        = @@bcc
    @from       = 'Foodmoves Support <support@foodmoves.com>'
    @sent_on    = Time.now
  end

  # sent when an administrator is unable to verify a user's affiliation to a company    
  def denial(user, company, affiliation)
    @subject    = "Unable to authorize #{user.name} to trade at Foodmoves.com"
    @body       = {:user => user,
                :company => company,
                :affiliation => affiliation}
    @recipients = user.email
    @bcc        = @@bcc
    @from       = 'Foodmoves Support <support@foodmoves.com>'
    @sent_on    = Time.now
  end
end
