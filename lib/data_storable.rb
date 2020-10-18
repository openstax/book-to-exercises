module DataStorable

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def data_store
    @data_store ||= self.class.data_store!
  end

  module ClassMethods
    def data_store!
      secrets = Rails.application.secrets.git

      GitDataStore.new(
        remote_url: secrets[:remote_url],
        directory: secrets[:directory],
        username: secrets[:username],
        password: secrets[:password]
      )
    end
  end

end
