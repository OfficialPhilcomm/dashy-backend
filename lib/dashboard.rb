require "slim"

class Dashboard
  def render
    Slim::Template.new("web/template.slim").render
  end
end
