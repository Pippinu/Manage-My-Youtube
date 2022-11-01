class VideoUpload < ApplicationRecord
    attribute :file, :binary
    attribute :title, :binary
    attribute :description, :text
  
    validates :file, presence: true
    validates :title, presence: true

    def upload!(user)
        account = Yt::Account.new access_token: user.token
        account.upload_video self.file, title: self.title, description: self.description
    end
end