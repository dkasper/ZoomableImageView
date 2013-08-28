Pod::Spec.new do |s|
  s.name         = "ZoomableImageView"
  s.version      = "0.0.1"
  s.summary      = "Zoomable Image View"
  s.homepage     = "https://github.com/substantial/ZoomableImageView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Substantial" => "https://github.com/substantial", "Mike Judge" => "https://github.com/mikelovesrobots" }
  s.source       = { :git => "https://github.com/substantial/ZoomableImageView.git", :tag => '0.0.1' }
  s.platform     = :ios, '5.1'

  s.source_files = 'ZoomableImageView', 'ZoomableImageView/**/*.{h,m}'
  s.frameworks   = 'Foundation', 'UIKit'

  s.requires_arc = true
end
