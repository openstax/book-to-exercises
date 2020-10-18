class Exercises
  def initialize(raw)
    @raw = raw
  end

  def source_html
    @raw.to_xhtml
  end
end
