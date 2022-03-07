//
//  BiYingH5BaseController.h
//  BiYing
//
//  Created by 周围 on 2017/10/10.
//  Copyright © 2017年 grx. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface SparkH5BaseController : UIViewController
@property (copy, nonatomic) NSString *H5Title;
@property (copy, nonatomic) NSString *h5Url;
@property (nonatomic, strong) UILabel *titleLable;
@property (strong, nonatomic) WKWebView *wkWebView;

@property (strong, nonatomic) UIProgressView *progressView;
- (void)startLoadWithTitle:(NSString *)title url:(NSString *)url;

@end
