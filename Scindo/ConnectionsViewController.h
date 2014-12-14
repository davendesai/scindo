//
//  ConnectionsViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectionsViewController : UIViewController <MCBrowserViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *txtName;
@property (nonatomic, weak) IBOutlet UISwitch *swVisible;
@property (nonatomic, weak) IBOutlet UITableView *tblConnected;
@property (nonatomic, weak) IBOutlet UIButton *btnDisconnect;

- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;

@end
