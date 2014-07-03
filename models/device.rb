class Device
  attr_accessor :name, :vendor_id

  def initialize(options)
    @name = options[:name]
    @vendor_id = options[:vendor_id]
  end
end
