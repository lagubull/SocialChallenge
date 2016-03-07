platform :ios, "8.0"

source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def socialChallenge_pods
    pod 'CoreDataServices', '1.1.4'
    pod 'PureLayout'
    pod 'EasyAlert'
    pod 'Reveal-iOS-SDK', '~> 1.6', :configurations => ['Debug']
    pod 'SimpleTableView', '~>1.0.3'
    pod 'EasyDownloadSession', '1.0.4'
    pod 'OCMock', '~>3.2'
end

target 'SocialChallenge' do
    socialChallenge_pods
end

target 'SocialChallengeTests' do
    socialChallenge_pods
end
