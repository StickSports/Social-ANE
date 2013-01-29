//
//  SocialMessage.h
//  SocialIosExtension
//
//  Created by Richard Lord on 29/01/2013.
//  Copyright (c) 2013 Richard Lord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

@interface SocialMessage : NSObject
{
}

- (id) initWithContext:( FREContext )extensionContext serviceType:( NSString* )serviceType;
- (BOOL) setMessage:(NSString *)message;
- (BOOL) addUrl:(NSString *)url;
- (BOOL) clearUrls;
- (BOOL) addImage:(UIImage *)image;
- (BOOL) clearImages;
- (BOOL) launchService;

@end
