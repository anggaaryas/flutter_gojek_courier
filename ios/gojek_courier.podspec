#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gojek_courier.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gojek_courier'
  s.version          = '0.0.2'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  
  s.dependency 'CourierCore', '0.0.16'
  s.dependency 'CourierMQTT', '0.0.16'
  s.dependency 'CourierProtobuf', '0.0.16'
  s.dependency 'ReachabilitySwift', '5.0.0'
  s.dependency 'SwiftProtobuf'
  
end
