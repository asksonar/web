require 'hashids'

module ActiveRecordHashids
  def self.included(base)
    base.extend(ClassMethods)
  end

  def hashid
    id && self.class.hashids.encode(id)
  end

  def to_param
    hashid
  end

  module ClassMethods
    def hashids
      @hashids ||= Hashids.new(self.name + 'f%jpdDF3c7ZZ@T&C7Zh^sk22gTKmxj#3', 8)
    end

    def find_by_hashid(hashid)
      find(hashids.decode(hashid)[0])
    end
  end

end
