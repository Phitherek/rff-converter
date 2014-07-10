class Conversion < ActiveRecord::Base
    belongs_to :key
    mount_uploader :original_file, MediaUploader
    validates :original_file, :presence => true
    validates :key, :presence => true, :uniqueness => true
    validates :convtype, :presence => true, :inclusion => {:in => [:audio, :video]}
    validates :mode, :presence => true, :inclusion => {:in => [:concurrent, :sequential]}
    validates :status, :presence => true, :inclusion => {:in => [:new, :processing, :completed, :failed]}
    validates :percentage, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
    
    scope :not_completed, -> {where(status: [:new, :processing])}
    scope :processing, -> {where(status: :processing)}
    scope :completed, -> {where(status: :completed)}
    scope :failed, -> {where(status: :failed)}
    
    def self.find_by_key key
        k = Key.where(keystring: key)
        Conversion.where(key: k).first
    end
    
    def format_percentage
        percentage.to_s + " %"
    end
    
    def to_json_status
        [status, percentage].to_json
    end
    
    def zipurl hostname
        str = zippath
        str[Rails.root.to_s] = ""
        str["/public"] = hostname
        str
    end
    
    def convtype
        read_attribute(:convtype).try(:to_sym)
    end
    
    def mode
        read_attribute(:mode).try(:to_sym)
    end
    
    def status
        read_attribute(:status).try(:to_sym)
    end
end
