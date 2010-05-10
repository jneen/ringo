module Ringo
  
  class Model
    class << self
      def key(*args)
        Ringo.key(:models, self.name, *args)
      end

      def index_key(*args)
        self.key(:indices, *args)
      end
    end

    def self.fields
      @fields ||= {}
    end

    def key(*args)
      self.class.key(:objects, self.id, *args)
    end

    def index_key(index, *args)
      self.class.index_key(index, self.send(index), *args)
    end

  end
end
