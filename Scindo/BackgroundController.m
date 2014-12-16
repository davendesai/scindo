//
//  BackgroundController.m
//  Scindo
//
//  Created by Daven Desai on 12/14/14.
//
//

#import "BackgroundController.h"

@interface BackgroundController ()

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) NSArray *pageIDs;
@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation BackgroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // TODO - Replace later with items from plist
    _pageIDs = @[@"SettingsView", @"MainView", @"TransactionsView"];
    _viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:[_pageIDs objectAtIndex:0]],
                         [self.storyboard instantiateViewControllerWithIdentifier:[_pageIDs objectAtIndex:1]],
                         [self.storyboard instantiateViewControllerWithIdentifier:[_pageIDs objectAtIndex:2]]];
        
    // Create page view controller
    _pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmptyView"];
    [_pageViewController setDataSource:self];
    [_pageViewController setViewControllers:@[[_viewControllers objectAtIndex:1]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    [self addChildViewController:_pageViewController];
    [_pageViewController.view setFrame:[self.view bounds]];
    [self.view addSubview:_pageViewController.view];
    
    [_pageViewController didMoveToParentViewController:self];
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

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    // Get index through storyboard/restoration ids
    NSString *identifier = [viewController restorationIdentifier];
    int index = (int)[_pageIDs indexOfObject:identifier];
    
    if (index == 0) return nil;
    index--;
    return [_viewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    // Get index through storyboard/restoration ids
    NSString *identifier = [viewController restorationIdentifier];
    int index = (int)[_pageIDs indexOfObject:identifier];

    index++;
    if (index == [_pageIDs count]) return nil;
    return [_viewControllers objectAtIndex:index];
}

@end
