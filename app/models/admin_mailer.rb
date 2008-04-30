class AdminMailer < ActionMailer::ARMailer
  @@bcc = 'archive@foodmoves.com'
  @@from = 'Foodmoves Support <support@foodmoves.com>'

  def affiliation(user, company, affiliation)
    @subject    = "Please verify #{user.name} works for #{company.name}"
    @body       = {:user => user,
                :company => company,
                :affiliation => affiliation}
    @recipients = 'Foodmoves Support <support@foodmoves.com>'
    @bcc        = @@bcc
    @from       = 'Foodmoves Admin <admin@foodmoves.com>'
    @sent_on    = Time.now
  end
  
  def spam_alert(user)
    @subject    = "ALERT: #{user.name} may be sending spam"
    @body       = {:user => user}
    @recipients = 'Foodmoves Admin <admin@foodmoves.com>'
    @bcc        = 'Foodmoves Support <support@foodmoves.com>'
    @from       = 'Foodmoves Admin <admin@foodmoves.com>'
    @sent_on    = Time.now
  end
  
  def account_suspended_alert(user)
    @subject    = "Foodmoves account has been suspended"
    @body       = {:user => user}
    @recipients = user.email
    @bcc        = 'Foodmoves Support <support@foodmoves.com>'
    @from       = @@from
    @sent_on    = Time.now
  end
end
