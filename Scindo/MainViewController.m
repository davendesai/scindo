//
//  MainViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "MainViewController.h"
#import "MPCFSessionContainer.h"

@interface MainViewController ()

@property (nonatomic, strong) MPCFSessionContainer *mpcfSessionContainer;
@property (nonatomic, strong) MCPeerID *origin;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Allocate Multipeer Connectivity Framework session at load
    _mpcfSessionContainer = [[MPCFSessionContainer alloc] init];
    
    // Start advertising
    [_mpcfSessionContainer initWithDisplayName:[UIDevice currentDevice].name];
    
    [_mpcfSessionContainer.advertiser.delegate self];
    [_mpcfSessionContainer.browser.delegate self];
    
    [_mpcfSessionContainer advertise:YES];
    [_mpcfSessionContainer browse:YES];
    
    // Record origin of transaction
    _origin = nil;
    
    [_tblConnected setDataSource:self];
    [_tblConnected setDelegate:self];
    [_tblConnected setAllowsMultipleSelection:YES];
    
    // Notification handlers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MPCFDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidStartTransactionWithNotification:)
                                                 name:@"MPCFDidStartTransactionNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    // For request view
    if ([[segue identifier] isEqualToString:@"RequestSegue"]) {
        // Get involved peers
        NSMutableArray *selected = [[NSMutableArray alloc] init];
        for (NSIndexPath *index in _tblConnected.indexPathsForSelectedRows) {
            MCPeerID *selectedPeer = [[_mpcfSessionContainer.session connectedPeers] objectAtIndex:index.row];
            [selected addObject:selectedPeer];
        }
        
        RequestViewController *reqViewController = (RequestViewController *)segue.destinationViewController;
        
        reqViewController.delegate = self;
        reqViewController.arrParticipants = [selected copy];
        
        // Send start transaction notification to all participants
        [_mpcfSessionContainer sendStartTransactionNotificationToPeers:selected];
    }
    // For send view
    else if ([[segue identifier] isEqualToString:@"SendSegue"]) {
        SendViewController *sendViewController = (SendViewController *)segue.destinationViewController;
        
        sendViewController.delegate = self;
        sendViewController.origin = _origin;
    }
}

#pragma mark - Notifications

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification {
    // Force update of UI on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tblConnected reloadData];
    });
}

- (void)peerDidStartTransactionWithNotification:(NSNotification *)notification {
    if (_origin == nil ) {
        // Record the origin to later pass on
        _origin = [[notification.userInfo valueForKey:@"origin"] copy];
        
        // Segue to sendview because requested
        [self performSegueWithIdentifier:@"SendSegue" sender:self];
    }
}

#pragma mark - RequestViewDelegate

- (void)finishedRequestView {

}

- (void)closedRequestView {
    
}

#pragma mark - SendViewDelegate

- (void)finishedSendView {
    // Reset origin to prepare for next transaction
    _origin = nil;
}

- (void)closedSendView {
    // Reset origin to prepare for next transaction
    _origin = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return [[_mpcfSessionContainer.session connectedPeers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    MCPeerID *id = [[_mpcfSessionContainer.session connectedPeers] objectAtIndex:indexPath.row];
    cell.textLabel.text = id.displayName;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![_btnStartTransaction isEnabled]) {
        [_btnStartTransaction setEnabled:YES];
    }
}

- (void)tableView:(UITableView *)tableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[_tblConnected indexPathsForSelectedRows] count] == 0) {
        [_btnStartTransaction setEnabled:NO];
    }
}

@end
