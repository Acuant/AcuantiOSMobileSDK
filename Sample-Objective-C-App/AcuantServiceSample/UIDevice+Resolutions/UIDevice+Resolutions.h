/*******************************************************************************
* This file is part of the UIDevice+Resolutions project.
*
* Copyright (c) 2012 C4M PROD.
*
* UIDevice+Resolutions is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* UIDevice+Resolutions is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with UIDevice+Resolutions. If not, see <http://www.gnu.org/licenses/lgpl.html>.
*
* Contributors:
* C4M PROD
******************************************************************************/

enum {
    UIDeviceResolution_Unknown          = 0,
    UIDeviceResolution_iPhoneStandard   = 1,    // iPhone 1,3,3GS Standard Display    (320x480px)
    UIDeviceResolution_iPhoneRetina35   = 2,    // iPhone 4,4S Retina Display 3.5"    (640x960px)
    UIDeviceResolution_iPhoneRetina4    = 3,    // iPhone 5 Retina Display 4"         (640x1136px)
    UIDeviceResolution_iPhoneRetina47   = 4,    // iPhone 6 Retina Display 4.7"       (750x1334px)
    UIDeviceResolution_iPhoneRetina55   = 5,    // iPhone 6 Plus Retina Display 5.5"  (1242x2208px)
    UIDeviceResolution_iPadStandard     = 6,    // iPad 1,2 Standard Display          (1024x768px)
    UIDeviceResolution_iPadRetina       = 7     // iPad 3 Retina Display              (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;


#import <UIKit/UIKit.h>

@interface UIDevice (Resolutions)


- (UIDeviceResolution)resolution;

NSString *NSStringFromResolution(UIDeviceResolution resolution);


@end
