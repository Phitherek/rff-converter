class Key < ActiveRecord::Base
    has_one :conversion
    validates :keystring, :presence => true, :length => {:is => 20}, :uniqueness => true
    
    def self.generate
        k = self.new
        k.keystring = Forgery(:basic).text(:exactly => 20)
        while !k.save
            k.keystring = Forgery(:basic).text(:exactly => 20)
        end
        k
    end
    
    def to_s
        self.keystring
    end
end
