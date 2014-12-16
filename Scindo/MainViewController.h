//
//  MainViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <UIKit/UIKit.h>
#import "RequestViewController.h"
#import "SendViewController.h"

@interface MainViewController : UIViewController <RequestViewDelegate, SendViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tblConnected;
@property (nonatomic, weak) IBOutlet UIButton *btnStartTransaction;

#pragma mark - Notifications

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification;
- (void)peerDidStartTransactionWithNotification:(NSNotification *)notification;

@end
