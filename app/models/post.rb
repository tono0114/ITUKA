class Post < ApplicationRecord

  mount_uploader :images, ImagesUploader
end
