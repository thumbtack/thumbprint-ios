source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
workspace 'Thumbprint'

target 'Thumbprint' do
  project 'Thumbprint/Thumbprint'

  pod 'SnapKit', '~> 5.0'
  pod 'ThumbprintTokens', '~> 12.1.0'
  pod 'TTCalendarPicker'

  target 'ThumbprintTests' do
    pod 'SnapshotTesting'
  end
end

PROJECT_ROOT_DIR = File.dirname(File.expand_path(__FILE__))
PODS_DIR = File.join(PROJECT_ROOT_DIR, 'Pods')
PODS_TARGET_SUPPORT_FILES_DIR = File.join(PODS_DIR, 'Target Support Files')
