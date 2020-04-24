
# MARK: -  Shared
def shared_pods 
    use_frameworks!
    
    pod 'SwiftLint'
    pod 'SwiftGen'
end

# MARK: -  Targets
target 'TestTask42' do
    shared_pods

    target 'TestTask42Tests' do
      shared_pods
    end
end
