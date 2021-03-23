source 'https://cdn.cocoapods.org/'
platform :ios, '12.0'
workspace 'Thumbprint'
inhibit_all_warnings!
use_modular_headers!
install! 'cocoapods',
  generate_multiple_pod_projects: true,
  incremental_installation: true

project 'Thumbprint/Thumbprint'

pod 'SnapKit', '~> 5.0'
pod 'ThumbprintTokens', '~> 12.1.0'
pod 'TTCalendarPicker'

target 'Thumbprint' do
end

target 'ThumbprintTests' do
  pod 'SnapshotTesting'
end

target 'TestsHostApp' do
end

PROJECT_ROOT_DIR = File.dirname(File.expand_path(__FILE__))
PODS_DIR = File.join(PROJECT_ROOT_DIR, 'Pods')
PODS_TARGET_SUPPORT_FILES_DIR = File.join(PODS_DIR, 'Target Support Files')

post_install do |installer|
  apply_xcconfig_inheritance_workaround
end

# $(inherited) in an xcconfig setting does not inherit values from included files, instead it redefines the setting.
# Therefore to enable custom xcconfig files that augment CocoaPods xcconfig files, we must workaround this shortcoming.
# The approach implemented here is to provide an identical setting prefixed with PODS_, so that in our custom xcconfig
# file we can write: SOME_SETTING = $(PODS_SOME_SETTING) CUSTOM=1.
def apply_xcconfig_inheritance_workaround
  Dir.glob(File.join(PODS_TARGET_SUPPORT_FILES_DIR, "Pods-*")).each do |path|
    Dir.glob(File.join(path, "*.xcconfig")).each do |xcconfig|
      lines = File.readlines(xcconfig)
      settings_with_inherited = lines.select { |line| line =~ /\$\(inherited\)/ }

      # Ignore lines that have already been updated.
      settings_with_inherited.reject! { |line| line.start_with?("PODS_") }

      # Skip this file if there's nothing to update.
      next if settings_with_inherited.empty?

      settings_with_inherited_keys = settings_with_inherited.map { |setting| setting.split("=").first.strip }

      settings_with_inherited_keys.each do |key|
        index = lines.find_index { |l| l.start_with?(key) }
        line = lines[index]
        lines[index] = "PODS_#{line}"
        lines.insert(index + 1, "#{key} = $(PODS_#{key})\n")
      end

      File.open(xcconfig, 'w') do |fd|
        fd.write(lines.join)
      end
    end
  end
end
