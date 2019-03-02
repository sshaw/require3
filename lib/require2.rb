module Require2
  VERSION = "0.0.1".freeze

  class << self
    def require(config)
      lib, aliases = config.instance_of?(Hash) ? config.first : config

      first_load = Kernel::require(lib)
      return first_load unless first_load && aliases

      # Path/file name components.
      # lib can be frozen so we use sub() first
      lib = lib.sub(%r{\A(?:\.\.?/)+}, "")
      lib.sub!(/\.(?:rb|o|dll)\z/, "")

      case aliases
      when String
        set_alias(lib, aliases)
      when Array
        aliases.each { |name| set_alias("#{lib}/#{name}", name) }
      else
        aliases.each do |target, alias_as|
          target = target.to_s
          # If the target has a namespace use it as is
          target = "#{lib}/#{target}" unless target.include?("::")
          set_alias(target, alias_as)
        end
      end

      first_load
    end

    private

    def set_alias(target, alias_as)
      Object.const_set(camelize(alias_as), Object.const_get(camelize(target)))
    end

    def camelize(term)
      string = term.dup

      # More or less stolen from ActiveSupport::Inflector#camelize
      # https://api.rubyonrails.org/v4.2.6/classes/ActiveSupport/Inflector.html#method-i-camelize
      string.sub!(/\A[a-z\d]*/) { $&.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      string.gsub!(/\//, "::")
      string
    end
  end
end

def require2(name)
  Require2.require(name)
end
