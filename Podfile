# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def testing_pods
	pod 'Quick'
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
