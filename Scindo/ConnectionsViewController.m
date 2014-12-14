//
//  ConnectionsViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import "ConnectionsViewController.h"
#import "MPCFModel.h"

@interface ConnectionsViewController ()

@property (nonatomic, strong) MPCFModel *mpcfModel;

@end

@implementation ConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mpcfModel = [[MPCFModel alloc] init];
    
    // Start advertising on load
    [_mpcfModel setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [_mpcfModel advertiseSelf:_swVisible.isOn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)browseForDevices:(id)sender {
    [_mpcfModel setupMPCFBrowser];
    [[_mpcfModel browser] setDelegate:self];
    
    // TODO - Auto accept all invites here for invisible searching
    [self presentViewController:[_mpcfModel browser] animated:YES completion:nil];
}

- (IBAction)toggleVisibility:(id)sender {
    [_mpcfModel advertiseSelf:_swVisible.isOn];
}

- (IBAction)disconnect:(id)sender {
    [[_mpcfModel session] disconnect];
}

#pragma mark - MCBrowserViewControllerDelegate

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [[_mpcfModel browser] dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [[_mpcfModel browser] dismissViewControllerAnimated:YES completion:nil];
}

@end
