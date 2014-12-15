//
//  RequestViewController.h
//  Scindo
//
//  Created by Daven Desai on 12/14/14.
//
//

#import <UIKit/UIKit.h>

@interface RequestViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *btnClose;

#pragma mark - IBActions

- (IBAction)close:(id)sender;

@end
