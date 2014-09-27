# Uncomment this line to define a global platform for your project
# platform :ios, "6.0"

target "MKLayoutLibrary" do

end

target "MKLayoutLibraryTests" do
    pod 'Specta', '0.2.1'
    pod 'Expecta', '0.2.3'
    pod 'OCMockito'
end

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SDKROOT'] = 'iphoneos7.1'
    end
  end
end
