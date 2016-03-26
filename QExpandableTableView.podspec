#
# Be sure to run `pod lib lint QExpandableTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QExpandableTableView"
  s.version          = "0.1.0"
  s.summary          = "Easy implementation of an expandable table view."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What 
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, Coc  
  s.description      = <<-DESC
        The Cocoapod will be be an expandable table view. This cocoapod will show the user
        how to easily integrate an expandable table view, into a normal expandable table view.
	This Cocoapod has very good documentation that allows the user to easily pin-point what
   	they have to do to easily implement the cocoapod.
	DESC
  s.homepage         = "https://github.com/RupiDev/QExpandableTableView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Rupin Bhalla" => "rupin.bhalla@gmail.com" }
  s.source           = { :git => "https://github.com/RupiDev/QExpandableTableView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'QExpandableTableView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
