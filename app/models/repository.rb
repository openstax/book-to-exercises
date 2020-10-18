require 'fileutils'
require 'ostruct'

class Repository

  MAIN_BRANCH = "main"

  delegate_missing_to :git

  def is_git_repository?
    begin
      git
    rescue ArgumentError
      false
    end
  end

  def git
    Git.open(@directory)
  end

  def make_like_just_cloned!
    git.branch(MAIN_BRANCH).checkout

    if has_remote?
      # Blow away tags and fetch them back http://stackoverflow.com/a/5373319/1664216
      git.tags.map{|tag| git.delete_tag(tag.name)}
      git.fetch('origin', :tags => true)
      git.reset_hard("origin/#{MAIN_BRANCH}")
    end
  end

  def has_remote?
    @remote_url.present?
  end

  def commits(options={})
    begin
      log = git.log(1000000).object('master') # don't limit
      log = log.between(options[:between][0], options[:between][1]) if options[:between]
      log.tap(&:first) # tap to force otherwise lazy checks
    rescue Git::GitExecuteError => e
      raise NoCommitsError
    end
  end

  def current_branch_name
    git.lib.branch_current
  end

  def working_dir
    git.dir.to_s
  end

  protected

  def initialize(remote_url: nil, directory:, username: nil, password: nil)
    @remote_url = remote_url
    @directory = directory
    @username = username
    @password = password

    if !is_git_repository?
      if has_remote?
        Git.clone(@remote_url, @directory)
      else

        Git.init(@directory).tap do |git|
          # Setup our info
          git.config("user.email", @username || "someuser") if git.config("user.email").blank?
          git.config("user.password", @password || "somepass") if git.config("user.password").blank?

          # Write a file so we can change the branch from master to main
          File.write(File.join(@directory, ".gitignore"), "w")
          git.add(".gitignore")
          git.commit("First commit")

          # Change the branch to main
          branch = git.branch(MAIN_BRANCH)
          branch.checkout
        end
      end
    end
  end

end
