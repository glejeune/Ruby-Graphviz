class String
  def self.random(size)
    s = ""
    d = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    size.times {
      s << d[rand(d.size)]
    }
    return s
  end
end

# From : http://www.geekmade.co.uk/2008/09/ruby-tip-normalizing-hash-keys-as-symbols/
class Hash
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
end
