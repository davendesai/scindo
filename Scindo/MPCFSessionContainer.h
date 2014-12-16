//
//  MPCFSessionContainer.h
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPCFSessionContainer : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) MCPeerID *id;
@property (nonatomic, strong) MCSession *session;

@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

#pragma mark - MPCFSessionDelegate

- (void)initWithDisplayName:(NSString *)displayName;

- (void)advertise:(BOOL)shouldAdvertise;
- (void)browse:(BOOL)shouldBrowse;

- (BOOL)sendStartTransactionNotificationToPeers:(NSArray *)peers;

@end
