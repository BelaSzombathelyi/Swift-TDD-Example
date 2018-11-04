# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

def testing_pods
	pod 'Quick', :inhibit_warnings => true
	pod 'Nimble'
end

target 'Game of Life' do

  target 'Game of LifeTests' do
    inherit! :search_paths
	 testing_pods
  end

  target 'Game of LifeUITests' do
    inherit! :search_paths
    testing_pods
  end

end

post_install do |installer|
   installer.pods_project.targets.each do |target|
      if target.name == 'Quick'
         target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
         end
      end
      target.build_configurations.each do |config|
         config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
         config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
      end
   end
end
