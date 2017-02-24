class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@randband.herokuapp.com'
  layout 'mailer'
end
