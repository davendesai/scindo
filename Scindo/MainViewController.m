//
//  MainViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "MPCFSessionContainer.h"
#import "MainViewController.h"

#import "RequestViewController.h"
#import "SendViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) MPCFSessionContainer *mpcfSessionContainer;

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
    
    [_tblConnected setDataSource:self];
    [_tblConnected setDelegate:self];
    [_tblConnected setAllowsMultipleSelection:YES];
    
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
    
    // Get involved peers
    NSMutableArray *selected = [[NSMutableArray alloc] init];
    for (NSIndexPath *index in _tblConnected.indexPathsForSelectedRows) {
        MCPeerID *selectedPeer = [[_mpcfSessionContainer.session connectedPeers] objectAtIndex:index.row];
        [selected addObject:selectedPeer];
    }

    // For request view
    if ([[segue identifier] isEqualToString:@"RequestSegue"]) {
        RequestViewController *reqViewController = (RequestViewController *)segue.destinationViewController;
        reqViewController.arrParticipants = [selected copy];
        
        // Send start transaction notification to all participants
        NSDictionary *dict = @{@"command" : @"start"};
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        NSError *error = nil;
        
        // TODO - Abstact out into MPCFSessionContainer
        if (![_mpcfSessionContainer.session sendData:data
                                             toPeers:selected
                                            withMode:MCSessionSendDataReliable
                                               error:&error]) {
            NSLog(@"[Error] (Should be OK in production) %@", error);
        }
    }
    // For send view
    else if ([[segue identifier] isEqualToString:@"SendSegue"]) {
        SendViewController *sendViewController = (SendViewController *)segue.destinationViewController;
        sendViewController.arrParticipants = [selected copy];
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
    // TODO - Do different things based on kind of data received
    [self performSegueWithIdentifier:@"SendSegue" sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_mpcfSessionContainer.session connectedPeers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    MCPeerID *id = [[_mpcfSessionContainer.session connectedPeers] objectAtIndex:indexPath.row];
    cell.textLabel.text = id.displayName;
    
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
