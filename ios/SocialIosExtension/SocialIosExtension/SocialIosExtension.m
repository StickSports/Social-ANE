//
//  SocialIosExtension.m
//  SocialIosExtension
//
//  Created by Richard Lord on 28/01/2013.
//  Copyright (c) 2013 Richard Lord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "FlashRuntimeExtensions.h"
#import "SocialTypeConversion.h"
#import "SocialMessage.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

Social_TypeConversion* converter;

DEFINE_ANE_FUNCTION( isSupported )
{
    // Check for presence of SLComposeViewController class.
    BOOL localPlayerClassAvailable = (NSClassFromString(@"SLComposeViewController")) != nil;
    
    // The device must be running iOS 6.0 or later.
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    uint32_t retValue = (localPlayerClassAvailable && osVersionSupported) ? 1 : 0;
    
    FREObject result;
    if ( FRENewObjectFromBool(retValue, &result ) == FRE_OK )
    {
        return result;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( isAvailableForService )
{
    NSString* serviceType;
    if( [converter FREGetObject:argv[0] asSocialService:&serviceType] != FRE_OK ) return NULL;
    
    BOOL available = NO;
    if ( [SLComposeViewController isAvailableForServiceType:serviceType] )
    {
        available = YES;
    }
    FREObject asAvailable;
    if( [converter FREGetBool:available asObject:&asAvailable] == FRE_OK )
    {
        return asAvailable;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( initialiseMessage )
{
    FREObject asTrue;
    FREObject asFalse;
    if ( FRENewObjectFromBool( NO, &asFalse ) != FRE_OK ) return NULL;
    if ( FRENewObjectFromBool( YES, &asTrue ) != FRE_OK ) return asFalse;
    
    NSString* serviceType;
    if( [converter FREGetObject:argv[0] asSocialService:&serviceType] != FRE_OK ) return asFalse;
    SocialMessage* social = [[SocialMessage alloc] initWithContext:context serviceType:serviceType];
    [social retain];
    FRESetContextNativeData( context, social );
    return asTrue;
}

DEFINE_ANE_FUNCTION( setMessage )
{
    FREObject asTrue;
    FREObject asFalse;
    if ( FRENewObjectFromBool( NO, &asFalse ) != FRE_OK ) return NULL;
    if ( FRENewObjectFromBool( YES, &asTrue ) != FRE_OK ) return asFalse;
    
    NSString* message;
    if( [converter FREGetObject:argv[0] asString:&message] != FRE_OK ) return asFalse;
    
    SocialMessage* social;
    FREGetContextNativeData( context, (void**)&social );

    if( social != nil )
    {
        if( [social setMessage:message] )
        {
            return asTrue;
        }
    }
    return asFalse;
}

DEFINE_ANE_FUNCTION( addUrl )
{
    FREObject asTrue;
    FREObject asFalse;
    if ( FRENewObjectFromBool( NO, &asFalse ) != FRE_OK ) return NULL;
    if ( FRENewObjectFromBool( YES, &asTrue ) != FRE_OK ) return asFalse;
    
    NSString* url;
    if( [converter FREGetObject:argv[0] asString:&url] != FRE_OK ) return asFalse;
    
    SocialMessage* social;
    FREGetContextNativeData( context, (void**)&social );
    
    if( social != nil && [social addUrl:url] )
    {
        return asTrue;
    }
    return asFalse;
}

DEFINE_ANE_FUNCTION( clearUrls )
{
    FREObject asTrue;
    FREObject asFalse;
    if ( FRENewObjectFromBool( NO, &asFalse ) != FRE_OK ) return NULL;
    if ( FRENewObjectFromBool( YES, &asTrue ) != FRE_OK ) return asFalse;
    
    SocialMessage* social;
    FREGetContextNativeData( context, (void**)&social );
    
    if( social != nil && [social clearUrls] )
    {
        return asTrue;
    }
    return asFalse;
}

DEFINE_ANE_FUNCTION( addImage )
{
    FREObject asTrue;
    FREObject asFalse;
    if ( FRENewObjectFromBool( NO, &asFalse ) != FRE_OK ) return NULL;
    if ( FRENewObjectFromBool( YES, &asTrue ) != FRE_OK ) return asFalse;
    
    UIImage* image;
    if( [converter FREGetObject:argv[0] asImage:&image] != FRE_OK ) return asFalse;
    
    SocialMessage* social;
    FREGetContextNativeData( context, (void**)&social );
    
    if( social != nil && [social addImage:image] )
    {
        return asTrue;
    }
    return asFalse;
}

DEFINE_ANE_FUNCTION( clearImages )
{
    FREObject asTrue;
    FREObject asFalse;
    if ( FRENewObjectFromBool( NO, &asFalse ) != FRE_OK ) return NULL;
    if ( FRENewObjectFromBool( YES, &asTrue ) != FRE_OK ) return asFalse;
    
    SocialMessage* social;
    FREGetContextNativeData( context, (void**)&social );
    
    if( social != nil && [social clearImages] )
    {
        return asTrue;
    }
    return asFalse;
}

DEFINE_ANE_FUNCTION( launch )
{
    FREObject asTrue;
    FREObject asFalse;
    if ( FRENewObjectFromBool( NO, &asFalse ) != FRE_OK ) return NULL;
    if ( FRENewObjectFromBool( YES, &asTrue ) != FRE_OK ) return asFalse;
    
    SocialMessage* social;
    FREGetContextNativeData( context, (void**)&social );
    
    if( social != nil && [social launchService] )
    {
        return asTrue;
    }
    return asFalse;
}

void SocialContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    if( strcmp( ctxType, "object" ) == 0 )
    {
        static FRENamedFunction objectFunctionMap[] =
        {
            MAP_FUNCTION( initialiseMessage, NULL ),
            MAP_FUNCTION( setMessage, NULL ),
            MAP_FUNCTION( addUrl, NULL ),
            MAP_FUNCTION( clearUrls, NULL ),
            MAP_FUNCTION( addImage, NULL ),
            MAP_FUNCTION( clearImages, NULL ),
            MAP_FUNCTION( launch, NULL )
        };
        
        *numFunctionsToSet = sizeof( objectFunctionMap ) / sizeof( FRENamedFunction );
        *functionsToSet = objectFunctionMap;
    }
    else
    {
        static FRENamedFunction staticFunctionMap[] =
        {
            MAP_FUNCTION( isSupported, NULL ),
            MAP_FUNCTION( isAvailableForService, NULL )
        };
        
        *numFunctionsToSet = sizeof( staticFunctionMap ) / sizeof( FRENamedFunction );
        *functionsToSet = staticFunctionMap;
    }
}

void SocialContextFinalizer( FREContext ctx )
{
    id social;
    FREGetContextNativeData( ctx, (void**)&social );
    if( social != nil )
    {
        if( [social isKindOfClass:[SocialMessage class] ] )
        {
            [social release];
        }
    }
	return;
}

void SocialExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet )
{
    extDataToSet = NULL;
    *ctxInitializerToSet = &SocialContextInitializer;
    *ctxFinalizerToSet = &SocialContextFinalizer;
    
    converter = [[[Social_TypeConversion alloc] init] retain];
}

void SocialExtensionFinalizer()
{
    [converter release];
    return;
}