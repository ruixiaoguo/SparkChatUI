//
//  SetWebViewController.m
//  Spark
//
//  Created by GRX on 2021/9/22.
//

#import "IDSWebViewController.h"

@interface IDSWebViewController ()

@end

@implementation IDSWebViewController
///pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self startLoadWithTitle:self.navTitle url:self.webUrl];
}


@end
