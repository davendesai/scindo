//
//  AppDelegate.m
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import "AppDelegate.h"
#import "MPCFSessionContainer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Allocate Multipeer Connectivity Framework session at load
    _mpcfSessionContainer = [[MPCFSessionContainer alloc] init];
    
    // Start advertising
    [_mpcfSessionContainer setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [_mpcfSessionContainer advertiseSelf:YES];
    
    ///////////////////////////////////////////////////////
    /**
     *  TESTING
     *
     *  Create and dispath methods for testing MPCF methods via GCD simulating differing wait times
     *  for clients that appear/disappear.
     *
     */////////////////////////////////////////////////////
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(1);  // simulating a thread being tied up for 1 seconds
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{@"peerID":[[MCPeerID alloc] initWithDisplayName:@"Test's iPhone"],
                                   @"state" :[[NSNumber alloc] initWithInt:MCSessionStateConnected]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCFDidChangeStateNotification"
                                                                object:nil
                                                              userInfo:dict];
        });
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(3);  // simulating a thread being tied up for 3 seconds
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{@"peerID":[[MCPeerID alloc] initWithDisplayName:@"Another Test's iPhone"],
                                   @"state" :[[NSNumber alloc] initWithInt:MCSessionStateConnected]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCFDidChangeStateNotification"
                                                                object:nil
                                                              userInfo:dict];
        });
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(7);  // simulating a thread being tied up for 7 seconds
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{@"peerID":[[MCPeerID alloc] initWithDisplayName:@"Yet Another Test's iPhone"],
                                   @"state" :[[NSNumber alloc] initWithInt:MCSessionStateConnected]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCFDidChangeStateNotification"
                                                                object:nil
                                                              userInfo:dict];
        });
    });
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
