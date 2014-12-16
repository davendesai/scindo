//
//  RequestViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/14/14.
//
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "RequestViewController.h"
#import "RequestViewCell.h"

@interface RequestViewController ()

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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

- (IBAction)transact:(id)sender {
    // Notify delegate that we are done
    [self.delegate finishedRequestView];
    
    [self dismissViewControllerAnimated:YES completion:nil];}

- (IBAction)close:(id)sender {
    // Notify delegate that we are done
    [self.delegate closedRequestView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrParticipants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RequestViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"participantCell"];
    
    if (cell == nil) {
        cell = [[RequestViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"participantCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(RequestViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Update information for each custom cell
    MCPeerID *id = [_arrParticipants objectAtIndex:indexPath.row];
    NSString *name = id.displayName;
    
    [cell.lblName setText:name];
    [cell.lblAmount setText:@"$0"];
}

@end
