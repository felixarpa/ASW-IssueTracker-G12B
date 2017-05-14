class AttachedFile < ActiveRecord::Base
  belongs_to :issue
  has_attached_file :file
  validates_attachment :file, presence: true
  do_not_validate_attachment_file_type :file
  validates_attachment :file, size: { in: 0..5.megabytes }

  def as_json(options = {})
    super();
    {
      name: file_file_name,
      type: file_content_type,
      url: file.url,
      href: "/attached_files/#{id}"
    }
  end
end