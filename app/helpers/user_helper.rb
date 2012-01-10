module UserHelper

    def gravatar_for(user)
        gravatar_image_tag(
            user.email.downcase, 
            :alt => h(user.name),
            :class => 'gravatar')
    end
end
