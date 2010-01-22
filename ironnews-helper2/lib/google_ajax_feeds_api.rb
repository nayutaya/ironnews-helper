
module GoogleAjaxFeedsApi
  def self.create_parameter(options = {})
    options = options.dup
    url = options.delete(:url) || nil
    num = options.delete(:num) || 10

    return {
      "v"      => "1.0",
      "output" => "json",
      "q"      => url,
      "num"    => num.to_s,
    }
  end
end
