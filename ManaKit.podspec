#
# Be sure to run `pod lib lint ManaKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ManaKit'
  s.version          = '2.7.2'
  s.summary          = 'Core Data implementation of MTGJSON.com.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A database of Magic: The Gathering cards. Includes prices and images.
                       DESC

  s.homepage         = 'https://github.com/jovito-royeca/ManaKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jovito-royeca' => 'jovit.royeca@gmail.com' }
  s.source           = { :git => 'https://github.com/jovito-royeca/ManaKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ManaGuideApp'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ManaKit/Classes/**/*'
  
  s.resource_bundles = {
   'ManaKit' => ['ManaKit/Assets/**/*']
  }

  s.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => "$(SDKROOT)/usr/include/libxml2" }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit', 'Sync', 'DATASource', 'DATAStack', 'Kanna', 'PromiseKit', 'Reachability', 'SSZipArchive', 'SDWebImage'
  s.dependency 'Sync'
  s.dependency 'DATASource'
  s.dependency 'DATAStack'
  s.dependency 'Kanna', '~> 3'
  s.dependency 'PromiseKit'
  s.dependency 'Reachability'
  s.dependency 'SSZipArchive'
  s.dependency 'SDWebImage'
end
