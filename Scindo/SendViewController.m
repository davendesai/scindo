//
//  SendViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/16/14.
//
//

#import "SendViewController.h"
#import "TransactionContainer.h"

@interface SendViewController ()

@property (nonatomic, strong) TransactionContainer *transactionContainer;

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Allocate Transaction at load
    _transactionContainer = [[TransactionContainer alloc] init];
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

- (IBAction)close:(id)sender {
    // TODO - Cancel gracefully, right now just close everything
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
