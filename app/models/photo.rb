class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  has_many :activities

  attr_accessible :comment, :title, :url, :user_id, :sport_id#,:tags

  #serialize :tags, Array
  #before_save :set_tags
  # Necesitamos un Array[Hash] para almacenar los tags
  # a = Array.new(2,Hash.new)
  # a[0]['cat'] = 'feline'
  # a # => [{"cat"=>"feline"},{"cat"=>"feline"}]
  # [1]['cat'] = 'Felix'
  # a # => [{"cat"=>"Felix"},{"cat"=>"Felix"}]

  # a = Array.new(2){Hash.new} # Multiple instances
  # a[0]['cat'] = 'feline'
  # a # =>[{"cat"=>"feline"},{}]

  #def after_initialize
  #  self.tags ||= Array.new
  #end

  #def set_tags
  #  if self.tags.is_a? String
  #    self.tags = self.tags.split(", ")
  #  end
  #end

  def self.upload_file(fileUp)
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAJOMNP4NKMHY3AZOA',
      :secret_access_key => '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'
    )
    
    filename = rand(36**32).to_s(36) + File.extname(fileUp.original_filename)
    
    # Carga el archivo
    AWS::S3::S3Object.store(filename, fileUp.read, 'letsjock-photos', :access => :public_read)
    url = AWS::S3::S3Object.url_for(filename, 'letsjock-photos', :authenticated => false)
  end

end
