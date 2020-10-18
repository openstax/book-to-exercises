require_relative 'content'
require 'nokogiri'

class Page < Content
  def doc
    @doc ||= Nokogiri::XML(html){|config| config.noblanks}
  end

  def exercises
    doc.search('.exercises, .section-exercises')
  end
end
