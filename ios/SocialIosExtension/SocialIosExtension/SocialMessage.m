//
//  SocialMessage.m
//  SocialIosExtension
//
//  Created by Richard Lord on 29/01/2013.
//  Copyright (c) 2013 Richard Lord. All rights reserved.
//

#import "SocialMessage.h"
#import <Social/Social.h>
#import "SocialInternalMessages.h"

@interface SocialMessage ()
{
}
@property (nonatomic, assign) FREContext context;
@property (nonatomic, retain) SLComposeViewController* controller;
@property (nonatomic, retain) NSString* serviceType;

@end

@implementation SocialMessage

@synthesize context, controller, serviceType;

- (id) initWithContext:( FREContext )extensionContext serviceType:(NSString *)service
{
    self = [super init];
    if( self )
    {
        self.context = extensionContext;
        self.serviceType = service;
        self.controller = [SLComposeViewController composeViewControllerForServiceType:service];
    }
    return self;
}

- (BOOL) setMessage:(NSString *)message
{
    return [self.controller setInitialText:message];
}

- (BOOL) addUrl:(NSString *)url
{
    return [self.controller addURL:[NSURL URLWithString:url]];
}

- (BOOL) clearUrls
{
    return [self.controller removeAllURLs];
}

- (BOOL) addImage:(UIImage *)image
{
    return [self.controller addImage:image];
}

- (BOOL) clearImages
{
    return [self.controller removeAllImages];
}

- (BOOL) launchService
{
    SLComposeViewControllerCompletionHandler __block completionHandler = ^(SLComposeViewControllerResult result)
    {
        [controller dismissViewControllerAnimated:YES completion:nil];
        switch( result )
        {
            case SLComposeViewControllerResultCancelled:
            default:
                FREDispatchStatusEventAsync( context, "", messageCancelled );
                break;
            case SLComposeViewControllerResultDone:
                FREDispatchStatusEventAsync( context, "", messageComplete );
                break;
        }
    };
    
    [controller setCompletionHandler:completionHandler];
    
    UIViewController *mainViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [mainViewController presentViewController:controller animated:YES completion:nil];
    
    return YES;
}

- (void) dealloc
{
    [serviceType release];
    [controller release];
    [super dealloc];
}

@end
