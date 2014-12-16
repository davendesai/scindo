//
//  MainViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tblConnected;
@property (nonatomic, weak) IBOutlet UIButton *btnStartTransaction;

#pragma mark - Notifications

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification;
- (void)peerDidStartTransactionWithNotification:(NSNotification *)notification;

@end
