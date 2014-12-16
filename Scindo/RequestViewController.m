//
//  RequestViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/14/14.
//
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "RequestViewController.h"


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
    // TODO - Cancel gracefully, right now just close everything
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    // TODO - Cancel gracefully, right now just close everything
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrParticipants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    MCPeerID *id = [_arrParticipants objectAtIndex:indexPath.row];
    NSString *output = id.displayName;
    
    // TODO - Add more information to transaction participants
    [output stringByAppendingString:@" has pledged $0"];
    
    cell.textLabel.text = output;
    return cell;
}

@end
