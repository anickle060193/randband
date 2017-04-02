require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    u = users( :johnsmith )
    u.activation_token = "ABCD"
    mail = UserMailer.account_activation( u )
    assert_equal "RandBand Account Activation", mail.subject
    assert_equal [ "john.smith@test.com" ], mail.to
    assert_equal [ "noreply@randband.herokuapp.com" ], mail.from
    assert_match "Hello johnsmith", mail.body.encoded
  end

  test "password_reset" do
    u = users( :johnsmith )
    u.reset_token = "ABCD"
    mail = UserMailer.password_reset( u )
    assert_equal "RandBand Password Reset", mail.subject
    assert_equal [ "john.smith@test.com" ], mail.to
    assert_equal [ "noreply@randband.herokuapp.com" ], mail.from
    assert_match "To reset your password", mail.body.encoded
  end

end
