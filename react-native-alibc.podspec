require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = package['name']
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/greatGua/react-native-alibc.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/RNAlibc/*.{h,m}"

  s.preserve_paths  = "*.js"
  s.frameworks      = 'CoreTelephony','CoreMotion'
  s.vendored_frameworks = "ios/RNAlibc/AlibcTradeSDK/Frameworks/*.framework" #工程依赖的第三方framework
  s.libraries       = 'libz','libsqlite3'
  # s.vendored_libraries = "ios/RNAlibc/*.a"

  s.dependency 'React'
end
