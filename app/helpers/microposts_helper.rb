# helpers should only be used for views (and are accessible by default in views)
# other methods to be used in controllers should be placed or in the
# ApplicationControler or in lib/ in order to enforce separation of concerns/abstraction
module MicropostsHelper

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text :
                                  text.scan(regex).join(zero_width_space)
    end
end