#
# Be sure to run `pod lib lint Translator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Translator'
  s.version          = '1.0.0'
  s.summary          = 'A lightweight Swift utility for translating text to English using async/await and modern concurrency patterns.'

  s.description      = <<-DESC
  Translator is a developer-friendly, Swift-based translation utility that enables seamless conversion of any source text to English. Built with Swift concurrency and async/await architecture, it offers clean syntax, high performance, and easy integration into modern iOS/macOS apps.

  Ideal for localisation workflows, AI-driven text preprocessing, or simple utility extensions, Translator encapsulates best practices in error handling and asynchronous API consumption. Whether you're building a multilingual app or just need dynamic English translations, this utility ensures efficiency without added overhead.
                       DESC

  s.homepage         = 'https://github.com/akashtala/Translator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Akash Tala' => 'akashpatel54668@gmail.com' }
  s.source           = { :git => 'https://github.com/akashtala/Translator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'

  s.source_files = 'Source/**/*'
  
end
