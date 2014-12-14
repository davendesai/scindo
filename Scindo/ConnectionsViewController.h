//
//  ConnectionsViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectionsViewController : UIViewController <MCBrowserViewControllerDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tblConnected;

#pragma mark - IBActions

- (IBAction)browseForDevices:(id)sender;
- (IBAction)disconnect:(id)sender;

#pragma mark - Notifications

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@end
