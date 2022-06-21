#
# Be sure to run `pod lib lint Thumbprint.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name = 'Thumbprint'
  s.version = '2.1.12'
  s.summary = 'iOS implementation of Thumbprint design system'

  s.description = <<-DESC
Design system for building user interfaces at Thumbtack.
                DESC

  s.homepage = 'https://github.com/thumbtack/thumbprint-ios'
  s.documentation_url = 'https://thumbprint.design'
  s.source = { :git => 'https://github.com/thumbtack/thumbprint-ios.git', :tag => s.version.to_s }
  s.license = { :type => 'Apache 2', :file => 'LICENSE' }
  s.authors = {
    'Ahad Islam' => 'aislam@thumbtack.com',
    'Bryan Jensen' => 'bryan@thumbtack.com',
    'Chris Cornelis' => 'ccornelis@thumbtack.com',
    'Daniel Roth' => 'droth@thumbtack.com',
    'Darvish Kamalia' => 'kamalia@thumbtack.com',
    'Eric Seo' => 'eseo@thumbtack.com',
    'Erica Ehrhardt' => 'eee@thumbtack.com',
    'Kevin Beaulieu' => 'kevinb@thumbtack.com',
    'Lee Arellano' => 'lee@thumbtack.com',
    'Óscar Morales Vivó' => 'omoralesvivo@thumbtack.com',
    'Santiago Gil' => 'santi@thumbtack.com',
    'Scott Southerland' => 'scottasoutherland@thumbtack.com',
  }

  s.swift_version = '5.0'
  s.platform = :ios
  s.ios.deployment_target = '13.0'

  s.source_files = 'Thumbprint/Targets/Thumbprint/**/*.swift'
  s.resource_bundles = {
    'ThumbprintResources' => ['Thumbprint/Targets/ThumbprintResources/**/*.xcassets'],
  }

  s.frameworks = 'UIKit'

  s.dependency 'SnapKit', '~> 5.0'
  s.dependency 'ThumbprintTokens', '~> 12.1.0'
  s.dependency 'TTCalendarPicker'
end
