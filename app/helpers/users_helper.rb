module UsersHelper

  def gravatar_url( user, size: 80 )
    id = Digest::MD5::hexdigest( user.email.downcase )
    return "https://secure.gravatar.com/avatar/#{id}?s=#{size}"
  end

end
