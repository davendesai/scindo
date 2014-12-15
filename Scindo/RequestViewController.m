//
//  RequestViewController.m
//  Scindo
//
//  Created by Daven Desai on 12/14/14.
//
//

#import "RequestViewController.h"
#import "AppDelegate.h"


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

- (IBAction)close:(id)sender {
    // TODO - Cancel gracefully, right now just close everything
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
