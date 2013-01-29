//
//  MoPubTypeConversion.m
//  MoPubIosExtension
//
//  Created by Richard Lord on 18/06/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

@interface Social_TypeConversion : NSObject

- (FREResult) FREGetObject:(FREObject)object asInt:(int32_t*)value;
- (FREResult) FREGetObject:(FREObject)object asString:(NSString**)value;
- (FREResult) FREGetObject:(FREObject)object asSocialService:(NSString**)value;
- (FREResult) FREGetObject:(FREObject)object asImage:(UIImage**)value;

- (FREResult) FREGetBool:(BOOL)value asObject:(FREObject*)asObject;

@end
