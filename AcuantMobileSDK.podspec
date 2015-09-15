Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.name = "AcuantMobileSDK"
  s.version = "4.5"
  s.summary = "AcuantMobileSDK"

  s.description  = <<-DESC
                   The AcuantMobileSDK.framework is a Cocoa Framework is designed to simplify your development efforts. The processing of the captured images takes place via Acuant’s Web Services. Our Web Services offer fast data extraction and zero maintenance as software is looked after by Acuant on our optimized cloud infrastructure.

                    Benefits:

                    -   Process Enhancement: Faster data extraction and process images via Acuant’s Web Services.

                    -   Easy to set up and deploy.
                    
                    -   No maintenance and support: All maintenance and updates are done on Acuant servers.
                    
                    -   Secured Connection: Secured via SSL and HTTPS AES 256-bit encryption.
                    
                    Acuant Web Services supports processing of drivers licenses, state IDs, other govt issued IDs, custom IDs, driver’s license barcodes, passports, medical insurance cards etc.
                   DESC

  s.homepage = "https://github.com/Acuant/iOSSDKCocoaPods"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license = { 
        :type => 'commercial',
        :text => <<-LICENSE
                Copyright 2015 Acuant, Inc. All Rights Reserved.
                LICENSE
        }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author = { 
    "vgargacuant" => "vgarg@acuantcorp.com" 
    }

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source = { :git => "https://github.com/Acuant/iOSSDKCocoaPods.git", :tag => 'v4.5' }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform = :ios

  s.ios.deployment_target = "8.1"

  s.ios.xcconfig = { 
        'GCC_PREPROCESSOR_DEFINITIONS' => 'DEBUG=1 $(inherited) CVLIB_IMG_NOCODEC'
  }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.source_files = "AcuantMobileSDK.framework/Versions/4.5/Headers/*.{h}"
  s.ios.header_dir = 'AcuantMobileSDK'
  s.ios.public_header_files = "AcuantMobileSDK.framework/Versions/4.5/Headers/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.ios.resources = "AcuantMobileSDK.framework/Versions/4.5/Resources/*.{*}"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.frameworks = 'AcuantMobileSDK', 'AssetLibrary', 'SystemConfiguration', 'AudioToolbox', 'AVFoundation', 'CoreMedia', 'CoreVideo', 'CoreGraphics', 'QuartzCore'
  s.libraries = "iconv", "c++", "z"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.requires_arc = false

end
