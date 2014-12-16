//
//  SendViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/16/14.
//
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface SendViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *btnClose;

@property (nonatomic, strong) NSMutableArray *arrParticipants;

#pragma mark - IBActions

- (IBAction)close:(id)sender;

@end
