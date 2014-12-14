//
//  MPCFSessionContainer.h
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPCFSessionContainer : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *id;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

#pragma mark - MPCFSessionDelegate

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void)setupMPCFBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;

@end
