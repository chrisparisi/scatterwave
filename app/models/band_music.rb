class BandMusic < ApplicationRecord
  belongs_to :band

  has_attached_file :music
  validates_attachment_content_type :music, content_type: [/\Aaudio\/.*\z/, 'application/x-mp3', 'application/octet-stream']
  validates_attachment_size :music, less_than: 10.megabytes

end
