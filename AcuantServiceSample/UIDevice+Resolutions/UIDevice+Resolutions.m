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



#import "UIDevice+Resolutions.h"

@implementation UIDevice (Resolutions)


- (UIDeviceResolution)resolution
{
	UIDeviceResolution resolution = UIDeviceResolution_Unknown;
	UIScreen *mainScreen = [UIScreen mainScreen];
	CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
	CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina35;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            else if (pixelHeight == 1334.0f)
                resolution = UIDeviceResolution_iPhoneRetina47;
            else if (pixelHeight == 2208.0f)
                resolution = UIDeviceResolution_iPhoneRetina55;
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
		
	} else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
			
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
	}
	
	return resolution;
}



@end
