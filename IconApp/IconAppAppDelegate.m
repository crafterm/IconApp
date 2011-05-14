//
//  IconAppAppDelegate.m
//  IconApp
//
//  Created by Marcus Crafter on 14/05/11.
//  Copyright 2011 Red Artisan. All rights reserved.
//

#import "IconAppAppDelegate.h"
#import "IconViewController.h"

@implementation IconAppAppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = [[[IconViewController alloc] init] autorelease];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc {
    [_window release];
    
    [super dealloc];
}

@end
