# Don't do image resizing in test
if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end