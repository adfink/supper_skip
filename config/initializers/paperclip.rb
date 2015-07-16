Paperclip.interpolates(:placeholder) do |attachment, style|
  ActionController::Base.helpers.asset_path("default_image.jpg")
end
