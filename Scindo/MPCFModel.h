//
//  MPCFModel.h
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPCFModel : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *id;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void)setupMPCFBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;

@end
