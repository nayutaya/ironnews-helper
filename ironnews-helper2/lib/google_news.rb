
module GoogleNews
  def self.create_params(options = {})
    options = options.dup
    keyword = options.delete(:keyword) || raise(ArgumentError)
    num     = options.delete(:num) || 10
    raise(ArgumentError) unless options.empty?

    return {
      "hl"     => "ja",
      "ned"    => "us",
      "ie"     => "UTF-8",
      "oe"     => "UTF-8",
      "output" => "rss",
      "num"    => num.to_s,
      "q"      => keyword,
    }
  end
end
