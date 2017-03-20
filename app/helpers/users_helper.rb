module UsersHelper

  def gravatar_url( user, size: 80 )
    id = Digest::MD5::hexdigest( user.email.downcase )
    return "https://secure.gravatar.com/avatar/#{id}?s=#{size}"
  end

  def gravatar_tag( user, size: 80 )
    url = gravatar_url( user, size: size )
    image_tag( url, alt: user.username, width: size, height: size, class: "img-circle gravatar" )
  end

end
