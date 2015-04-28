#
#  Be sure to run `pod spec lint Game-Timer-iOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Game-Timer-iOS"
  s.version      = "1.0.0"
  s.summary      = "Light-weight timer that you can use for iOS games."

  s.description  = <<-DESC
                   GameTimer incorporates 2 timers that work in unison - referred to as longTimer and shortTimer. The shortTimer acts as a 'finer' resolution timer that can be used to update a progressbar or continually poll a network connection (for example). It's interval is usually set to a fraction of the longTimer.

                   GameTimer automatically pauses when the app enters the BACKGROUND and 'unpauses' when the app is ACTIVE again.
                   DESC

  s.homepage     = "https://github.com/pjebs/Game-Timer-iOS"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "PJ Engineering and Business Solutions Pty. Ltd." => "enquiries@pjebs.com.au" }

  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/pjebs/Game-Timer-iOS.git", :tag => "v1.0.0" }
  s.source_files  = "*.{h,m}"
  s.requires_arc = true

end
