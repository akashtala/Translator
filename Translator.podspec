#
# Be sure to run `pod lib lint Translator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Translator'
  s.version          = '0.0.1'
  s.summary          = 'A short description of Translator.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/talaakash/Translator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Akash Tala' => 'akashpatel54668@gmail.com' }
  s.source           = { :git => 'https://github.com/akashtala/Translator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'Source/**/*'
  
end
