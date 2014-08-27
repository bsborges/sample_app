module UsersHelper
    # http://en.gravatar.com/site/implement/hash/
    # To ensure a consistent and accurate hash, the following steps should be taken to create a hash:
    # Trim leading and trailing whitespace from an email address
    # Force all characters to lower-case
    # md5 hash the final string
    
    # Returns the Gravatar (http://gravatar.com/) for the given user.
    def gravatar_for(user, options = { size: 50 })
        gravatar_id = Digest::MD5::hexdigest(user.email.to_s.downcase)
        size = options[:size]
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
end
