module AdminHelper

  def boolean_tag( b )
    if b
      content_tag( :span, "", class: "glyphicon glyphicon-ok" )
    else
      content_tag( :span, "", class: "glyphicon glyphicon-remove" )
    end
  end

end
