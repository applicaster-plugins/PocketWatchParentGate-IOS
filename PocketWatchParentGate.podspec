Pod::Spec.new do |s|
  s.name             = 'PocketWatchParentGate'
  s.version          = '0.1.8'
  s.summary          = 'A PocketWatchParentGate plugin that integrates to Applicaster Zapp based applications'
  s.description      = 'A PocketWatchParentGate plugin that integrates to Applicaster Zapp based applications'
  s.homepage         = 'https://github.com/applicaster-plugins/PocketWatchParentGate-IOS'
  s.license          = 'MIT'
  s.author           = { 'Andrii Novoselskyi' => 'andrii.novoselskyi@corewillsoft.com' }
  s.source           = { :git => 'git@github.com:applicaster-plugins/PocketWatchParentGate-IOS.git', :tag => s.version.to_s }

  s.platform            = :ios, '10.0'
  s.requires_arc        = true

  s.frameworks = 'UIKit'
  s.source_files = 'PocketWatchParentGate/Sources/**/*'

  s.static_framework = true

  s.resource_bundles = {
    'PocketWatchParentGate' => ['PocketWatchParentGate/Assets/*']
  }
  
    s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
        'FRAMEWORK_SEARCH_PATHS' => '$(inherited)',
        'OTHER_LDFLAGS' => '$(inherited)',
        'ENABLE_BITCODE' => 'YES',
        'SWIFT_VERSION' => '5.1',
        'OTHER_CFLAGS'  => '-fembed-bitcode'
    }

  s.dependency 'ZappPlugins'
  s.dependency 'Firebase/Messaging', '~> 7.0.0'
  s.dependency 'Firebase/Core', '~> 7.0.0'

end
