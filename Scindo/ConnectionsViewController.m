//
//  ConnectionsViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/13/14.
//
//

#import "ConnectionsViewController.h"
#import "MPCFSessionContainer.h"
#import "AppDelegate.h"

@interface ConnectionsViewController ()

@property (nonatomic, weak) MPCFSessionContainer *mpcfSessionContainer;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

@end

@implementation ConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _mpcfSessionContainer = [delegate mpcfSessionContainer];
    
    _arrConnectedDevices = [[NSMutableArray alloc] init];
    [_tblConnected setDataSource:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MPCFDidChangeStateNotification"
                                               object:nil];
    
    ///////////////////////////////////////////////////////
    /**
     *  TESTING
     *
     *  Create and dispath methods for testing MPCF methods via GCD simulating differing wait times
     *  for clients that appear/disappear.
     *
     */////////////////////////////////////////////////////
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(1);  // simulating a thread being tied up for 1 seconds
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{@"peerID":[[MCPeerID alloc] initWithDisplayName:@"Test's iPhone"],
                                   @"state" :[[NSNumber alloc] initWithInt:MCSessionStateConnected]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCFDidChangeStateNotification"
                                                                object:nil
                                                              userInfo:dict];
        });
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(3);  // simulating a thread being tied up for 3 seconds
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{@"peerID":[[MCPeerID alloc] initWithDisplayName:@"Another Test's iPhone"],
                                   @"state" :[[NSNumber alloc] initWithInt:MCSessionStateConnected]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCFDidChangeStateNotification"
                                                                object:nil
                                                              userInfo:dict];
        });
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(7);  // simulating a thread being tied up for 7 seconds
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{@"peerID":[[MCPeerID alloc] initWithDisplayName:@"Yet Another Test's iPhone"],
                                   @"state" :[[NSNumber alloc] initWithInt:MCSessionStateConnected]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCFDidChangeStateNotification"
                                                                object:nil
                                                              userInfo:dict];
        });
    });
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

- (IBAction)disconnect:(id)sender {
    [[_mpcfSessionContainer session] disconnect];
}

#pragma mark - Notifications

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification {
    MCPeerID *id = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerName = id.displayName;
    
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    // Update UI
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_arrConnectedDevices addObject:peerName];
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedDevices count] > 0) {
                int index = (int)[_arrConnectedDevices indexOfObject:peerName];
                [_arrConnectedDevices removeObjectAtIndex:index];
            }
        }
    }
    
    // HACK - Force a reload of the table whenever a change is detected
    [_tblConnected reloadData];
}

#pragma mark - MCBrowserViewControllerDelegate

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [[_mpcfSessionContainer browser] dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [[_mpcfSessionContainer browser] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableViewDataSource

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

@end
