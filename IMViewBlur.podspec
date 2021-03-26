Pod::Spec.new do |s|
  s.name = 'IMViewBlur'
  s.version = '0.0.1'
  s.summary  = 'A clean and lightweight progress HUD for your iOS app.'
  s.description = 'IMViewBlur is a clean and easy-to-use View Blur meant to blur view on iOS.'
  
  s.homepage = 'https://github.com/immortal-it/IMViewBlur'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Immortal' => 'immortal@gmail.com' }
  s.source = { :git => 'https://github.com/immortal-it/IMViewBlur.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.requires_arc = true
  s.swift_versions = ['5.1', '5.2', '5.3']
  
  s.source_files = 'IMViewBlur/**/*.{swift}'

  s.pod_target_xcconfig = {
    'SWIFT_INSTALL_OBJC_HEADER' => 'NO'
  }
  
end
