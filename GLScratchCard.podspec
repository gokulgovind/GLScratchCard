#
# Be sure to run `pod lib lint GLScratchCard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GLScratchCard'
  s.version          = '0.1.0'
  s.summary          = 'GLScratch card is a library that replicate the scratch card functionality of Google Pay (Tez, GPay), PhonePe'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'I loved the way payments app\'s like Google pay and phone pe used scratch card option to reward it\'s user. Hence with 💛 cloned the same scratch card effect for you guys out there'

  s.homepage         = 'https://github.com/gokulgovind/GLScratchCard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'gokulece26@gmail.com'
  s.source           = { :git => 'https://github.com/gokulgovind/GLScratchCard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'GLScratchCard/Classes/**/*'
  
  s.resource_bundles = {
    'GLScratchCard' => ['GLScratchCard/Classes/*.{png,xib}']
  }
  s.swift_versions = '4.0'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
