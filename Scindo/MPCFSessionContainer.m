//
//  MPCFSessionContainer.m
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import "MPCFSessionContainer.h"

@implementation MPCFSessionContainer

- (id)init {
    if (self = [super init]) {
        _id = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
    return self;
}

- (void)initWithDisplayName:(NSString *)displayName {
    // Create multipeer connection session
    _id = [[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer:_id];
    _session.delegate = self;
    
    // Setup advertiser
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_id
                                                        discoveryInfo:nil
                                                          serviceType:@"scindo"];
    // Setup browser
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_id
                                                    serviceType:@"scindo"];
}

- (void)advertise:(BOOL)shouldAdvertise {
    shouldAdvertise ? [_advertiser startAdvertisingPeer] : [_advertiser stopAdvertisingPeer];
}

- (void)browse:(BOOL)shouldBrowse {
    shouldBrowse ? [_browser startBrowsingForPeers] : [_browser stopBrowsingForPeers];
}

- (BOOL)sendStartTransactionNotificationToPeers:(NSArray *)peers {
    // Send start command to specified peers
    NSDictionary *dict = @{@"command" : @"start"};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    return [_session sendData:data
                      toPeers:peers
                     withMode:MCSessionSendDataReliable
                        error:nil];
}

#pragma mark - MCSessionDelegate

// TODO - Don't have to worry about this until I have actual test devices

-(void)session:(MCSession *)session
          peer:(MCPeerID *)peerID
didChangeState:(MCSessionState)state {
    
    // Create properly formed notification
    NSDictionary *dict = @{@"origin" : peerID,
                           @"state"  : [NSNumber numberWithInt:state]};
    
    // Send peer information to host
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCFDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}

-(void)session:(MCSession *)session
didReceiveData:(NSData *)data
      fromPeer:(MCPeerID *)peerID {
    
    // TODO - Make sure you encode the same way when sending data
    NSDictionary *receivedDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *command = [receivedDict valueForKey:@"command"];
    
    if ([command isEqualToString:@"start"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCFDidStartTransactionNotification"
                                                            object:nil
                                                          userInfo:@{@"origin" : peerID}];
    }
}

-(void)session:(MCSession *)session
didReceiveStream:(NSInputStream *)stream
      withName:(NSString *)streamName
      fromPeer:(MCPeerID *)peerID {
    
}

- (void)session:(MCSession *)session
didStartReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID
   withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session
didFinishReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL
      withError:(NSError *)error {
    
}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    // Auto-invite any peers that are found
    [_browser invitePeer:peerID
               toSession:_session
             withContext:nil
                 timeout:5.0];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    // SHOULD NEVER HAVE TO DO THIS
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    // SHOULD NEVER HAVE TO DO THIS
}

#pragma mark - MCNearbyServiceAdvertiserDelegate methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    
    // Auto-accept any invitations received
    invitationHandler(YES, _session);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    // SHOULD NEVER HAVE TO DO THIS
}

@end
