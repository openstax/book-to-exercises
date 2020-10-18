require 'fileutils'
require 'json'

class GitDataStore < DataStore

  # /admins
  # /qas
  # /books
  # /pages

  # /books/book_uuid - store page UUIDs

  def initialize(remote_url: nil, directory:, username: nil, password: nil)
    @repository = Repository.new(remote_url: remote_url,
                                 directory: directory,
                                 username: username,
                                 password: password)

    @repository.make_like_just_cloned!
  end

  def enqueue_book_version_scrape(book_version)
    in_sync do
      write_file("books/pending/#{book_version.id}", add: true)
      repository.commit("Enqueued scrape for #{book_version.id}")
    end
  end

  def pending_book_version_ids
    in_sync do
      Dir.glob(File.join(@repository.working_dir, "books/pending/*")).map do |file_path|
        File.basename(file_path)
      end
    end
  end

  def mark_book_version_scraped(book_version)
    raise "nyi"
  end


  def book_version_already_scraped?(book_version)
    in_sync do
      file_exists?("books/scraped/#{book_version.id}")
    end
  end

  def page_version_already_scraped?(page_version)
    in_sync do
      file_exists?("pages/#{page_version.id}.json")
    end
  end

  def write_exercises_source_html(page_version:, source_html:)
    in_sync do
      write_file("pages/#{page_version.id}/source.html", add: true)
    end
  end

  def write_exercise(page_version:, filename:, body:)
    in_sync do
      write_file("pages/#{page_version.id}/#{filename}", body: body.to_json, add: false)
    end
  end

  def update_page_exercises_json(page_version:)
    in_sync do
      body = {}.to_json # TODO put real exercises in
      write_file("pages/#{page_version.id}.json", body: body, add: true)
    end
  end

  def download
    return if !repository.has_remote?
  end

  def upload
    return if !repository.has_remote?
  end

  protected

  attr_reader :repository

  def write_file(relative_file_path, body: nil, add: false)
    absolute_file_path = File.join(repository.working_dir, relative_file_path)

    dirname = File.dirname(absolute_file_path)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    File.open(absolute_file_path, 'w') do |file|
      file.write(body) if body.present?
    end

    repository.add(relative_file_path) if add
  end

  def file_exists?(relative_file_path)
    absolute_file_path = File.join(repository.working_dir, relative_file_path)
    File.exist?(absolute_file_path)
  end

  def in_sync
    download
    result = yield
    upload
    result
  end

end
