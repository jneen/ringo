class String
  unless defined? squish
    def squish
      strip.gsub(/\s+/,' ')
    end
  end
end
