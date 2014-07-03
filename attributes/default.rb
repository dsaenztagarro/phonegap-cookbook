require 'models/device'

node.default[:phonegap][:devices] = [
  Device.new(name: "Motorola G", vendor_id: "2e76")
]
