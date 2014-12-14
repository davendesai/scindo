//
//  LandingViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface LandingViewController : UIViewController <MCBrowserViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tblConnected;
@property (nonatomic, weak) IBOutlet UIButton *btnStartTransaction;

#pragma mark - IBActions

- (IBAction)browseForDevices:(id)sender;
- (IBAction)startTransaction:(id)sender;

#pragma mark - Notifications

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@end
