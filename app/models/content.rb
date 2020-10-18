require 'json'

class Content
  include DataStorable

  attr_reader :id

  ID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}@\d+(\.\d+)?$/

  def initialize(id)
    raise "Content cannot have a nil `id`" if id.nil?
    raise "ID '#{id}' must be of the form UUID@version" unless id.match(ID_REGEX)
    @id = id
  end

  def url
    "https://archive.cnx.org/contents/#{@id}"
  end

  def json
    @json ||= begin
      uri = URI(url + ".json")
      response = HTTParty.get(uri)
      JSON.parse(response.body)
    end
  end

  def html
    @html ||= begin
      uri = URI(url + ".html")
      HTTParty.get(uri).body
    end
  end

  def exists?
    HTTParty.head(url + ".json").success?
  end
end
