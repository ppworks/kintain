module SocialHelper
  def providers_checkbox
    return if current_user.scope.name == 'private'
    content_tag :ul, nil, {:class => :providers} {
      if current_user.has_provider? Provider.facebook.id
        concat content_tag :li, check_box_tag(:facebook, 1, 1, :class => :checkbox) +
        content_tag(:label, :for => 'facebook', :class => :checkbox) {
          'facebook'
        }
      end
      if current_user.has_provider? Provider.twitter.id
        concat content_tag :li, check_box_tag(:twitter, 1, 1, :class => :checkbox) +
        content_tag(:label, :for => 'twitter', :class => :checkbox) {
          'twitter'
        }
      end
      if current_user.has_provider? Provider.mixi.id
        concat content_tag :li, check_box_tag(:mixi, 1, 1, :class => :checkbox) +
        content_tag(:label, :for => 'mixi', :class => :checkbox) {
          'mixi'
        }
      end
    }
  end
  
end
