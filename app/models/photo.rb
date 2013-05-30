class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :competition
  belongs_to :recognition
  belongs_to :result
  belongs_to :team
  belongs_to :train
  belongs_to :trainee
  belongs_to :work

  has_many :activities

  attr_accessible :comment, :title, :url, :user_id, :competition_id, :recognition_id, :result_id, :team_id, :train_id, :sport_id, :trainee_id, :work_id
  
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
