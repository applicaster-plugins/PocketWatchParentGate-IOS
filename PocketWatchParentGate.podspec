Pod::Spec.new do |s|
  s.name             = 'PocketWatchParentGate'
  s.version          = '0.1.2'
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
  s.resources = 'PocketWatchParentGate/Assets/*'
  
  # s.resource_bundles = {
  #   'PocketWatchParentGate' => ['PocketWatchParentGate/Assets/*.png']
  # }

  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                'ENABLE_BITCODE' => 'YES',
                'OTHER_LDFLAGS' => '$(inherited)',
                'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
                'LIBRARY_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
                'SWIFT_VERSION' => '5.1'
              }

  s.dependency 'ZappPlugins'
  s.dependency 'UrbanAirship-iOS-SDK'

end
