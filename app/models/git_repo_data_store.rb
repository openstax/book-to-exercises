class GitRepoDataStore < DataStore

  def initialize(remote: nil, directory:)
    @remote = remote
    @directory = directory
  end



end
