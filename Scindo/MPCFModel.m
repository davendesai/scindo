//
//  MPCFModel.m
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import "MPCFModel.h"

@implementation MPCFModel

- (id)init {
    if (self = [super init]) {
        _id = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
    return self;
}

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName {
    _id = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_id];
    _session.delegate = self;
}

- (void)setupMPCFBrowser {
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"scindo"
                                                               session:_session];
}

- (void)advertiseSelf:(BOOL)shouldAdvertise {
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"scindo"
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else {
        [_advertiser stop];
        _advertiser = nil;
    }
}

#pragma mark - MCSessionDelegate

// TODO - Don't have to worry about this until I have actual test devices

-(void)session:(MCSession *)session
          peer:(MCPeerID *)peerID
didChangeState:(MCSessionState)state {
    
}


-(void)session:(MCSession *)session
didReceiveData:(NSData *)data
      fromPeer:(MCPeerID *)peerID {
    
}


-(void)session:(MCSession *)session
didStartReceivingResourceWithName:(NSString *)resourceName
      fromPeer:(MCPeerID *)peerID
  withProgress:(NSProgress *)progress {
    
}


-(void)session:(MCSession *)session
didFinishReceivingResourceWithName:(NSString *)resourceName
      fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL
     withError:(NSError *)error {
    
}


-(void)session:(MCSession *)session
didReceiveStream:(NSInputStream *)stream
      withName:(NSString *)streamName
      fromPeer:(MCPeerID *)peerID {
    
}

@end
