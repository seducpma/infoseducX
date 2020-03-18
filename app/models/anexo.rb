class Anexo < ActiveRecord::Base
  belongs_to :user
  belongs_to :unidade

  validates_presence_of :titulo,:unidade
  validates_associated :unidade

  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :whiny => false,
                      :url => "/photos/:class/:id.:extension",
                      :path => ":rails_root/public/photos/:class/:id.:extension"
  # before_post_process :image?

  validates_attachment_content_type :file, :content_type => %w(image/jpg image/jpeg image/pjpeg image/gif image/png image/x-png application/msword application/pdf )
  validates_attachment_size :file, :less_than => 5.megabytes




end
