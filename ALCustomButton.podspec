
Pod::Spec.new do |s|
  s.name             = 'ALCustomButton'
  s.version          = '1.0.0'
  s.summary          = 'An easily customizable reusable button.'

  s.description      = ""

  s.homepage         = 'https://github.com/applogistdev/ALCustomButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'unalCe' => 'unal.celik@applogist.com' }
  s.source           = { :git => 'https://github.com/applogistdev/ALCustomButton.git', :tag => '1.0.0' }
  
  s.social_media_url = 'https://twitter.com/unallce'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ALCustomButton/Classes/**/*'
  
end
