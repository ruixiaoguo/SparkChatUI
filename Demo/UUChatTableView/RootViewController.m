//
//  RootViewController.m
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "RootViewController.h"
#import "SparkInputFunctionView.h"
#import "SparkChatMessageCell.h"
#import "SparkChatModel.h"
#import "SparkChatMessageFrame.h"
#import "SparkChatMessage.h"
#import <MJRefresh/MJRefresh.h>
#import "SparkChatCategory.h"
#import "IDSWebViewController.h"
#import "PreViewController.h"
#define KeyBordToolsHight 90
#define mainWindows [[[UIApplication sharedApplication] delegate]window]
#define isIphoneX mainWindows.safeAreaInsets.bottom>0
#define BottemHight (isIphoneX ? 34 : 00)
#define WeakSelf(weakSelf) __weak typeof(self) weakSelf = self

@interface RootViewController ()<SparkInputFunctionViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
	CGFloat _keyboardHeight;
}
@property (strong, nonatomic) SparkChatModel *chatModel;

@property (strong, nonatomic) UITableView *chatTableView;

@property (strong, nonatomic) SparkInputFunctionView *inputFuncView;

@property (strong, nonatomic) NSString *currenRole;

@end

@implementation RootViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currenRole = @"Me";
    [self initBasicViews];
    [self addRefreshViews];
    [self loadBaseViewsAndData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = @"SparkChat";
    //add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustCollectionViewLayout) name:UIDeviceOrientationDidChangeNotification object:nil];
	[self tableViewScrollToBottom];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	if (_inputFuncView.textViewInput.isFirstResponder) {
		_chatTableView.frame = CGRectMake(0, 0, self.view.uu_width, self.view.uu_height-KeyBordToolsHight-_keyboardHeight);
		_inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.view.uu_width, KeyBordToolsHight);
	} else {
		_chatTableView.frame = CGRectMake(0, 0, self.view.uu_width, self.view.uu_height-KeyBordToolsHight-BottemHight);
		_inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.view.uu_width, KeyBordToolsHight);
	}
}

#pragma mark - prive methods

- (void)initBasicViews
{
	_chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.uu_width, self.view.uu_height-KeyBordToolsHight) style:UITableViewStylePlain];
	_chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_chatTableView.delegate = self;
	_chatTableView.dataSource = self;
	[self.view addSubview:_chatTableView];
	
	[_chatTableView registerClass:[SparkChatMessageCell class] forCellReuseIdentifier:NSStringFromClass([SparkChatMessageCell class])];
	
	_inputFuncView = [[SparkInputFunctionView alloc] initWithFrame:CGRectMake(0, _chatTableView.uu_bottom, self.view.uu_width, KeyBordToolsHight)];
    _inputFuncView.layer.borderWidth = 1;
	_inputFuncView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	_inputFuncView.delegate = self;
	[self.view addSubview:_inputFuncView];
    WeakSelf(weakSelf);
    _inputFuncView.selRooterBlock = ^(NSString *typeName) {
        weakSelf.currenRole = typeName;
    };
    _inputFuncView.selVoidBlock = ^{
        IDSWebViewController *idsVC = [[IDSWebViewController alloc]init];
        idsVC.navTitle = @"网络攻击";
        idsVC.webUrl = @"https://cybermap.kaspersky.com/cn";
        [weakSelf.navigationController pushViewController:idsVC animated:YES];
    };
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(PreViewClick)];
}

-(void)PreViewClick{
    PreViewController *preVC = [[PreViewController alloc]init];
    [self.navigationController pushViewController:preVC animated:YES];
}

- (void)addRefreshViews
{
//    __weak typeof(self) weakSelf = self;
    //load more
//    int pageNum = 10;
//	self.chatTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
////		[weakSelf.chatModel addRandomItemsToDataSource:pageNum];
////		if (weakSelf.chatModel.dataSource.count > pageNum) {
////			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
////			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////				[weakSelf.chatTableView reloadData];
////				[weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
////			});
////		}
//		[weakSelf.chatTableView.mj_header endRefreshing];
//	}];
}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[SparkChatModel alloc] init];
    self.chatModel.dataSource = [NSMutableArray array];
    NSDictionary *dic = @{@"strContent": @"Whats'up?",
                          @"type": @(UUMessageTypeText)};
    [self.chatModel addLeetOtherItem:dic];
    [self.chatTableView reloadData];
}
#pragma mark - notification event

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
	if (self.chatModel.dataSource.count==0) { return; }
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
	[self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
	_keyboardHeight = keyboardEndFrame.size.height;
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
	
	self.chatTableView.uu_height = self.view.uu_height - _inputFuncView.uu_height;
	self.chatTableView.uu_height -= notification.name == UIKeyboardWillShowNotification ? _keyboardHeight:0;
//	self.chatTableView.contentOffset = CGPointMake(0, self.chatTableView.contentSize.height-self.chatTableView.uu_height);
	self.inputFuncView.uu_top = self.chatTableView.uu_bottom;
    [UIView commitAnimations];
}

- (void)adjustCollectionViewLayout
{
	[self.chatModel recountFrame];
	[self.chatTableView reloadData];
}

#pragma mark - InputFunctionViewDelegate

- (void)SparkInputFunctionView:(SparkInputFunctionView *)funcView sendMessage:(NSString *)message
{
//    if (message.length==0) {
//        return;
//    }
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.textViewInput.text = @"";
    [self dealTheFunctionData:dic];
}

#pragma mark == tool
- (void)displayTableviewCell:(UITableViewCell *)cell withAnimationAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.chatModel.dataSource.count - 1) {
        cell.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            cell.alpha = 1;
        }];
    }
}

- (void)SparkInputFunctionView:(SparkInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)SparkInputFunctionView:(SparkInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    if ([self.currenRole isEqualToString:@"Me"]) {
        [self.chatModel addLeetMeItem:dic];
    }else if ([self.currenRole isEqualToString:@"Other"]){
        [self.chatModel addLeetOtherItem:dic];
    }else{
        [self.chatModel addLeetNarratorItem:dic];
    }
    [self.chatTableView reloadData];
	[self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SparkChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SparkChatMessageCell class])];
	cell.messageFrame = self.chatModel.dataSource[indexPath.row];
    [self displayTableviewCell:cell withAnimationAtIndexPath:indexPath];
    cell.selHeaderBlock = ^(NSString *headerName) {
        NSLog(@"点击头像====%@",headerName);
    };
    cell.cancleDataBlock = ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除这一条吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.chatModel.dataSource removeObjectAtIndex:indexPath.row];
            [self.chatTableView reloadData];
            [self tableViewScrollToBottom];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}


@end
