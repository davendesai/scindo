//
//  RequestViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/14/14.
//
//

#import <UIKit/UIKit.h>

@interface RequestViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tblParticipants;
@property (nonatomic, weak) IBOutlet UIButton *btnMakeTransaction;
@property (nonatomic, weak) IBOutlet UIButton *btnClose;

@property (nonatomic, strong) NSMutableArray *arrParticipants;

#pragma mark - IBActions

- (IBAction)transact:(id)sender;
- (IBAction)close:(id)sender;

@end
