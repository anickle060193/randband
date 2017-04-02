class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@rand.band'
  layout 'mailer'
end
