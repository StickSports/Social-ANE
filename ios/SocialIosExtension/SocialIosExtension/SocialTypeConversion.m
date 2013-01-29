//
//  MoPubTypeConversion.m
//  MoPubIosExtension
//
//  Created by Richard Lord on 23/10/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "SocialTypeConversion.h"
#import <Social/Social.h>

#define twitter 1
#define facebook 2
#define sinaWeibo 3

@implementation Social_TypeConversion

- (FREResult) FREGetObject:(FREObject)object asInt:(int32_t*)value
{
    return FREGetObjectAsInt32( object, value );
}

- (FREResult) FREGetObject:(FREObject)object asString:(NSString**)value
{
    FREResult result;
    uint32_t length = 0;
    const uint8_t* tempValue = NULL;
    
    result = FREGetObjectAsUTF8( object, &length, &tempValue );
    if( result != FRE_OK ) return result;
    
    *value = [NSString stringWithUTF8String: (char*) tempValue];
    return FRE_OK;
}

- (FREResult) FREGetObject:(FREObject)object asSocialService:(NSString**)value
{
    int32_t serviceTypeId;
    FREResult result;
    result = FREGetObjectAsInt32( object, &serviceTypeId );
    if( result != FRE_OK ) return result;
    
    switch( serviceTypeId )
    {
        case twitter:
            *value = SLServiceTypeTwitter;
            break;
        case facebook:
            *value = SLServiceTypeFacebook;
            break;
        case sinaWeibo:
            *value = SLServiceTypeSinaWeibo;
            break;
    }
    return FRE_OK;
}

// based on code at http://forums.adobe.com/message/4201451
- (FREResult) FREGetObject:(FREObject)object asImage:(UIImage**)value
{
    FREResult result;
    FREBitmapData2 bitmapData;
    result = FREAcquireBitmapData2( object, &bitmapData );
    if( result != FRE_OK ) return result;
    
    int width = bitmapData.width;
    int height = bitmapData.height;
    
    // make data provider from buffer
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
    
    // set up for CGImage creation
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo;
    
    if( bitmapData.hasAlpha )
    {
        if( bitmapData.isPremultiplied )
        {
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
        }
        else
        {
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;
        }
    }
    else
    {
        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    }
    
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    *value = [UIImage imageWithCGImage:imageRef];
    
    FREReleaseBitmapData( object );
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    return FRE_OK;
}


- (FREResult) FREGetBool:(BOOL)value asObject:(FREObject*)asObject
{
    return FRENewObjectFromBool( value, asObject );
}

@end
