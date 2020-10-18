require_relative 'content'
require 'nokogiri'

class PageVersion < Content
  def doc
    @doc ||= Nokogiri::XML(html){|config| config.noblanks}
  end

  def search(*args)
    doc.search(*args)
  end

  # def exercises
  #   Exercises.new(doc.search('.exercises, .section-exercises'))
  # end
end
