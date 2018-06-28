Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.name = 'AcuantMobileSDK'
  s.version = '5.8'
  s.summary = 'AcuantMobileSDK'
  s.homepage = 'http://www.acuantcorp.com'

  s.description  = <<-DESC
                   The AcuantMobileSDK.framework is a Cocoa Framework is designed to simplify your development efforts. The processing of the captured images takes place via Acuant’s Web Services. Our Web Services offer fast data extraction and zero maintenance as software is looked after by Acuant on our optimized cloud infrastructure.

                    Benefits:

                    -   Process Enhancement: Faster data extraction and process images via Acuant’s Web Services.

                    -   Easy to set up and deploy.
                    
                    -   No maintenance and support: All maintenance and updates are done on Acuant servers.
                    
                    -   Secured Connection: Secured via SSL and HTTPS AES 256-bit encryption.
                    
                    Acuant Web Services supports processing of drivers licenses, state IDs, other govt issued IDs, custom IDs, driver’s license barcodes, passports, medical insurance cards etc.
                   DESC

  #s.screenshots  = ['https://github.com/Acuant/AcuantiOSMobileSDK/blob/master/Logo.png']

  # ---  Archs ----
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7' }
  s.user_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7' }

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license = { 
        :type => 'commercial',
        :text => <<-LICENSE
                Copyright 2017 Acuant, Inc. All Rights Reserved.
                LICENSE
  }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author = { 
        'tbeheraacuant' => 'tbehera@acuantcorp.com' 
  }

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source = {
    :git => 'https://github.com/Acuant/AcuantiOSMobileSDK.git',
    :tag => 'v5.8'
  }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.preserve_paths = 'AcuantMobileSDK.embeddedframework/*'
  s.platform = :ios

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.deployment_target = '8.0'
  s.source_files = 'AcuantMobileSDK.embeddedframework/AcuantMobileSDK.framework/Versions/5.8/Headers/*.{h}'
  s.ios.header_dir = 'AcuantMobileSDK'
  s.public_header_files = 'AcuantMobileSDK.embeddedframework/AcuantMobileSDK.framework/Versions/5.8/Headers/*.h'
  s.resources = 'AcuantMobileSDK.embeddedframework/Resources/*.{strings,wav,png}'
  #s.ios.requires_arc = true
  
  s.ios.xcconfig = { 
        'GCC_PREPROCESSOR_DEFINITIONS' => 'CVLIB_IMG_NOCODEC',
'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/AcuantMobileSDK/AcuantMobileSDK.embeddedframework/**"'}

  s.ios.frameworks = 'AcuantMobileSDK','Accelerate','CoreLocation','ImageIO','CoreText','CoreMotion','SystemConfiguration','AudioToolbox','AVFoundation','CoreMedia','CoreVideo','CoreGraphics','QuartzCore'
  s.ios.libraries = 'iconv', 'c++', 'z'

end 
