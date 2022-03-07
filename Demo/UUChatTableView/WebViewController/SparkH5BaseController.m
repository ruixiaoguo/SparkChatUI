//
//  BiYingH5BaseController.m
//  BiYing
//
//  Created by 周围 on 2017/10/10.
//  Copyright © 2017年 grx. All rights reserved.
//
/*! app尺寸 */
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width
/** 屏幕比 */
#define ScreenRate Main_Screen_Width/320
/*! 屏幕比适配宽高 */
#define kWidth(R) (R)*(Main_Screen_Width)/375
#define kHeight(R) kWidth(R)

/*! 系统控件 */
#define kStatusBarHeight        (24.f)
#define NavStatusHeNavSight        (10.f)
#define SparkNavBarHeight    (44.f)
#define TabBarHeight    (49.f)

//判断iPhone X
#define isIphoneX mainWindows.safeAreaInsets.bottom>0
#define NavigbarTopMargin              (isIphoneX ? 24.f : 0.f)
#define NavigReadTopMargin              (isIphoneX ? 15.f : -5.f)
#define VipBoMargin              (isIphoneX ? 0.f : 24.f)

#define NavBarHeight           (isIphoneX ? 88.f : 64.f)//状态栏高度

//判断iPhone X系列
#define mainWindows [[[UIApplication sharedApplication] delegate]window]
#define kNavigationBarHeight    (isIphoneX ? 68.f : 44.f)

#define BottemHight (isIphoneX ? 34 : 00)

#define BokInfoHight (isIphoneX ? 20 : 12)
#define BokTilHight (isIphoneX ? 10 : 3)
#define BokZanHight (isIphoneX ? 30 : 24)
#define BottHight (isIphoneX ? 10 : 0)

#import "SparkH5BaseController.h"
#import <WebKit/WebKit.h>

@interface SparkH5BaseController () <WKUIDelegate, WKNavigationDelegate>

@property (strong, nonatomic) WKWebViewConfiguration *wkConfig;




@end

@implementation SparkH5BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    self.progressView.backgroundColor = [UIColor blackColor];
    self.progressView.progressTintColor= [UIColor redColor];;
    //设置进度条的高度
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [self.view addSubview:self.progressView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startLoadWithTitle:(NSString *)title url:(NSString *)url {
//    NSSet *types = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
//                                         WKWebsiteDataTypeMemoryCache]];
//    NSDate *dateFrom = [NSDate date];
//    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:dateFrom completionHandler:^{
    
//        self.titleLable.text = title;
//        self.navigationItem.titleView = self.titleLable;
//        self.titleLable.sd_layout.topSpaceToView(self.navigationItem.titleView, 0).centerXEqualToView(self.navigationItem.titleView).widthIs(kWidth(200)).heightIs(navBarHeight - 20);
    self.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:17],
    NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.H5Title = title;
        self.h5Url = url;
        NSString *urlString = url;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.timeoutInterval = 15.0f;
        [self.view addSubview:self.wkWebView];
        self.wkWebView.navigationDelegate = self;
        self.wkWebView.UIDelegate = self;
        self.wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        [self.wkWebView loadRequest:request];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress >= 0.8) {
            self.progressView.hidden = YES;
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
              
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark --- WKWKNavigationDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    self.progressView.hidden = YES;
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
    //延迟0.1s再执行刷新
      dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
      dispatch_after(delayTime, dispatch_get_main_queue(), ^{
          [webView evaluateJavaScript:@"window.scrollTo(0,0)" completionHandler:nil];
       });
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSString *js=@"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }"
    "var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    "document.body.style.marginLeft = '15px';"
    "document.body.style.marginRight = '15px';";
    js=[NSString stringWithFormat:js,Main_Screen_Width-50];
    [webView evaluateJavaScript:js completionHandler:nil];
    [webView evaluateJavaScript:@"imgAutoFit()" completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
    }];
    self.progressView.hidden = YES;
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 获取完整url并进行UTF-8转码
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark --- 懒加载
- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
    }
    return _wkConfig;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        //以下代码适配大小
//        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        NSString *jScript;
        if ([self.H5Title isEqualToString:@"Terms of Service"]) {
            jScript = @"";
        }else{
            jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        }
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *confifg = [[WKWebViewConfiguration alloc] init];
        confifg.userContentController = wkUController;
        confifg.selectionGranularity = WKSelectionGranularityCharacter;
        _wkWebView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-BottemHight) configuration:confifg];
        //监听WKWebView加载网页进度的estimatedProgress属性。
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        _wkWebView.backgroundColor = [UIColor blackColor];
    }
    return _wkWebView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
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

@end
