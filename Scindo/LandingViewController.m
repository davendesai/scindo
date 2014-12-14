//
//  ConnectionsViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import "LandingViewController.h"
#import "MPCFSessionContainer.h"
#import "AppDelegate.h"

@interface LandingViewController ()

@property (nonatomic, weak) MPCFSessionContainer *mpcfSessionContainer;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _mpcfSessionContainer = [delegate mpcfSessionContainer];
    
    _arrConnectedDevices = [[NSMutableArray alloc] init];
    
    [_tblConnected setDataSource:self];
    [_tblConnected setDelegate:self];
    [_tblConnected setAllowsMultipleSelection:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MPCFDidChangeStateNotification"
                                               object:nil];
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
    [_mpcfSessionContainer setupMPCFBrowser];
    [[_mpcfSessionContainer browser] setDelegate:self];
    
    // TODO - Auto accept all invites here
    [self presentViewController:[_mpcfSessionContainer browser] animated:YES completion:nil];
}

- (IBAction)startTransaction:(id)sender {
    
}

#pragma mark - Notifications

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification {
    MCPeerID *id = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerName = id.displayName;
    
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    // Update UI
    NSArray *selectedIndexes = [_tblConnected indexPathsForSelectedRows];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_arrConnectedDevices addObject:peerName];
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedDevices count] > 0) {
                
                // TODO - Remember to handle devices that silently leave
                int index = (int)[_arrConnectedDevices indexOfObjectIdenticalTo:peerName];
                [_arrConnectedDevices removeObjectAtIndex:index];
            }
        }
    }
    
    // HACK - Force a reload of the table whenever a change is detected but keep selections
    [_tblConnected reloadData];
    for (NSIndexPath *path in selectedIndexes) {
        [_tblConnected selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - MCBrowserViewControllerDelegate

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [[_mpcfSessionContainer browser] dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [[_mpcfSessionContainer browser] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrConnectedDevices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![_btnStartTransaction isEnabled]) {
        [_btnStartTransaction setEnabled:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[_tblConnected indexPathsForSelectedRows] count] == 0) {
        [_btnStartTransaction setEnabled:NO];
    }
}

@end
