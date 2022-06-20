source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'
workspace 'Thumbprint'
inhibit_all_warnings!
use_modular_headers!
install! 'cocoapods',
  generate_multiple_pod_projects: true,
  incremental_installation: true

project 'Thumbprint/Thumbprint'

pod 'SnapKit', '~> 5.0'
pod 'SwiftLint'
pod 'SwiftFormat/CLI'
pod 'ThumbprintTokens', '~> 12.1.0'
pod 'TTCalendarPicker'

target 'Thumbprint' do
end

target 'ThumbprintTests' do
  pod 'SnapshotTesting'
end

target 'TestsHostApp' do
end

target 'Playground' do
end

PROJECT_ROOT_DIR = File.dirname(File.expand_path(__FILE__))
PODS_DIR = File.join(PROJECT_ROOT_DIR, 'Pods')
PODS_TARGET_SUPPORT_FILES_DIR = File.join(PODS_DIR, 'Target Support Files')

post_install do |installer|
  apply_xcconfig_inheritance_workaround
  set_deployment_target(installer)
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

# Some of our depedencies may specify a version < 8.0 which causes a warning in Xcode. To avoid
# these warnings, here we just set IPHONEOS_DEPLOYMENT_TARGET for all pods equal to the version
# defined by the platform directive at the top of this file.
def set_deployment_target(installer)
  deployment_target = installer.podfile.root_target_definitions.first.platform.deployment_target.version

  all_build_configurations(installer).each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
  end
end

def all_build_configurations(installer, &block)
  configs = installer.generated_projects.map do |project|
    if block && !block.call(project)
      []
    else
      project.build_configurations.to_a + project.targets.map do |target|
        target.build_configurations.to_a
      end
    end
  end.flatten
end
