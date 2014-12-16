//
//  SendViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/16/14.
//
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol SendViewDelegate <NSObject>

- (void)finishedSendView;
- (void)closedSendView;

@end

@interface SendViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *btnSend;
@property (nonatomic, weak) IBOutlet UIButton *btnClose;

@property (nonatomic, weak) id <SendViewDelegate> delegate;
@property (nonatomic, weak) MCPeerID *origin;

#pragma mark - IBActions

- (IBAction)send:(id)sender;
- (IBAction)close:(id)sender;

@end
