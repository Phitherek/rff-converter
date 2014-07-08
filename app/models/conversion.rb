class Conversion < ActiveRecord::Base
    belongs_to :key
    mount_uploader :original_file, MediaUploader
    validates :original_file, :presence => true
    validates :key, :presence => true, :uniqueness => true
    validates :convtype, :presence => true, :inclusion => {:in => [:audio, :video]}
    validates :mode, :presence => true, :inclusion => {:in => [:concurrent, :sequential]}
    validates :status, :presence => true, :inclusion => {:in => [:new, :processing, :completed, :failed]}
    validates :percentage, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
    
    def self.find_by_key key
        k = Key.where(keystring: key)
        Conversion.where(key: k).first
    end
end
