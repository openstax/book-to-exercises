require 'net/http'
require 'json'

class Content
  def initialize(id)
    @id = id
  end

  def url
    "https://archive.cnx.org/contents/#{@id}"
  end

  def json
    @json ||= begin
      uri = URI(url + ".json")
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    end
  end

  def html
    @html ||= begin
      uri = URI(url + ".html")
      Net::HTTP.get(uri)
    end
  end
end
