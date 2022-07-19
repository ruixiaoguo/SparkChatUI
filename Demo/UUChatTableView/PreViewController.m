//
//  PreViewController.m
//  UUChatTableView
//
//  Created by GRX on 2022/3/4.
//  Copyright © 2022 uyiuyao. All rights reserved.
//

#import "PreViewController.h"
#import "SparkChatMessageCell.h"
#import "SparkChatModel.h"
#import "SparkChatMessageFrame.h"
#import "SparkChatMessage.h"
#import <MJRefresh/MJRefresh.h>
#import "SparkChatCategory.h"
#import "IDSWebViewController.h"
#import "ChatNavBarView.h"
#import "ToastManage.h"
#define KeyBordToolsHight 90
#define mainWindows [[[UIApplication sharedApplication] delegate]window]
#define isIphoneX mainWindows.safeAreaInsets.bottom>0
#define BottemHight (isIphoneX ? 34 : 00)
#define WeakSelf(weakSelf) __weak typeof(self) weakSelf = self
#define kNavigationBarHeight    (isIphoneX ? 68.f : 44.f)

@interface PreViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _keyboardHeight;
}
@property (strong, nonatomic) UITableView *chatTableView;
@property (strong, nonatomic) SparkChatModel *chatModel;
@property (nonatomic, assign) CGFloat oldContentOffsetY;//控制table滑动隐藏
@property (strong, nonatomic) ChatNavBarView *navBarView;
@property(nonatomic,strong)UIProgressView *rateProgressView;
@property (strong, nonatomic) NSMutableArray *allChatDataArray;

@end

@implementation PreViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.chatModel = [[SparkChatModel alloc] init];
    self.allChatDataArray = [NSMutableArray arrayWithCapacity:0];
    self.chatModel.dataSource = [NSMutableArray array];
    [self addChatTableView];
    [self gaintAllChatsData];
}

#pragma mark - prive methods

- (void)addChatTableView{
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.uu_width, self.view.uu_height-BottemHight) style:UITableViewStylePlain];
    self.chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
    [self.chatTableView addGestureRecognizer:tap];
    [self.view addSubview:self.chatTableView];
    [self.chatTableView registerClass:[SparkChatMessageCell class] forCellReuseIdentifier:NSStringFromClass([SparkChatMessageCell class])];
    self.navBarView = [[ChatNavBarView alloc]initWithFrame:CGRectMake(0, 0, self.view.uu_width, kNavigationBarHeight+24)];
    self.navBarView.alpha = 0;
    [self.view addSubview:self.navBarView];
    WeakSelf(weakSelf);
    self.navBarView.backBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    /** 章节进度 */
    self.rateProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.rateProgressView.frame = CGRectMake(0, self.view.uu_height-BottemHight-5, self.view.uu_width, 5);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    self.rateProgressView.transform = transform;
    self.rateProgressView.trackTintColor = [UIColor lightGrayColor];
    self.rateProgressView.progressTintColor = [UIColor orangeColor];
    self.rateProgressView.layer.masksToBounds = YES;
    [self.view addSubview:self.rateProgressView];
    self.rateProgressView.alpha = 0;
}

#pragma mark - =============默认滚动到底部================
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0) { return; }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark ==============Cell显示动画==================
- (void)displayTableviewCell:(UITableViewCell *)cell withAnimationAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.chatModel.dataSource.count - 1) {
        cell.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            cell.alpha = 1;
        }];
    }
}
#pragma mark - ===============TableViewDelegate====================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatModel.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SparkChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SparkChatMessageCell class])];
    cell.messageFrame = self.chatModel.dataSource[indexPath.row];
    [self displayTableviewCell:cell withAnimationAtIndexPath:indexPath];
    cell.selHeaderBlock = ^(NSString *headerName) {
        [self tapScreen];
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

#pragma mark ===============scrollView=================
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 获取开始拖拽时tableview偏移量
    self.oldContentOffsetY = self.chatTableView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.dragging) {
        if ([scrollView isEqual: self.chatTableView]) {
            if (self.chatTableView.contentOffset.y > self.oldContentOffsetY) {
                // 上滑
                [UIView animateWithDuration:0.5 animations:^{
                    self.navBarView.alpha = 0;
                    self.rateProgressView.alpha = 0;
                }];
            }
            else{
                // 下滑
                [UIView animateWithDuration:0.5 animations:^{
                    self.navBarView.alpha = 1;
                    self.rateProgressView.alpha = 1;
                }];
            }
        }
    }
}

#pragma mark============点击屏幕===================
- (void)tapScreen
{
    if (self.navBarView.alpha==1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.navBarView.alpha = 0;
            self.rateProgressView.alpha = 0;
        }];
    }
    //判断是否结束
    if (self.chatModel.dataSource.count >= self.allChatDataArray.count) {
        NSLog(@"===阅读完毕！！！！！");
        [ToastManage showCenterToastWith:@"阅读完毕"];
    }else{
        NSDictionary *dic = self.allChatDataArray[self.chatModel.dataSource.count];
        [self addNewChatMessageData:dic];
    }
}
#pragma mark - ===============新增一条对话====================
- (void)addNewChatMessageData:(NSDictionary *)dic
{
    NSString *addType = [NSString stringWithFormat:@"%@",dic[@"addType"]];
    if ([addType isEqualToString:@"0"]) {
        /** 主角 */
        [self.chatModel addLeetMeItem:dic];
    }else if ([addType isEqualToString:@"1"]){
        /** 配角 */
        [self.chatModel addLeetOtherItem:dic];
    }else if ([addType isEqualToString:@"2"]){
        /** 旁白 */
        [self.chatModel addLeetNarratorItem:dic];
    }
    [self.chatTableView reloadData];
    [self updateReadingProgress];
    [self tableViewScrollToBottom];
    
}

#pragma mark - ===============获取所有章节数据====================
- (void)gaintAllChatsData
{
    [self.allChatDataArray removeAllObjects];
    [self.chatModel.dataSource removeAllObjects];
    NSDictionary *dic1 = @{@"addType": @"2",@"strContent": @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream",
                          @"type": @(UUMessageTypeText)};
    NSDictionary *dic2 = @{@"addType": @"1",@"strContent": @"Whats'up?",
                          @"type": @(UUMessageTypeText)};
    NSDictionary *dic3 = @{@"addType": @"0",@"strContent": @"May you have enough happiness to make you sweet",
                          @"type": @(UUMessageTypeText)};
    NSDictionary *dic4 = @{@"addType": @"2",@"strContent": @"life when you miss someone so much that you just want to pick them",
                          @"type": @(UUMessageTypeText)};
    NSDictionary *dic5 = @{@"addType": @"1",@"strContent": @"who have touched their lives?",
                          @"type": @(UUMessageTypeText)};
    NSDictionary *dic6 = @{@"addType": @"0",@"strContent": @"When you were born,you were crying and everyone around you was smiling.Live your life so that when you die,you're the one who is smiling and everyone around you is crying！",
                          @"type": @(UUMessageTypeText)};
    NSDictionary *dic7 = @{@"addType": @"1",@"strContent": @"who have touched their lives?",
                          @"type": @(UUMessageTypeText)};
    NSDictionary *dic8 = @{@"addType": @"0",@"strContent": @"When you were born,you were crying and everyone around you was smiling.Live your life so that when you die,you're the one who is smiling and everyone around you is crying！",
                          @"type": @(UUMessageTypeText)};
    [self.allChatDataArray addObject:dic1];
    [self.allChatDataArray addObject:dic2];
    [self.allChatDataArray addObject:dic3];
    [self.allChatDataArray addObject:dic4];
    [self.allChatDataArray addObject:dic5];
    [self.allChatDataArray addObject:dic6];
    [self.allChatDataArray addObject:dic7];
    [self.allChatDataArray addObject:dic8];
    if (self.allChatDataArray.count!=0) {
        NSDictionary *dic = self.allChatDataArray[0];
        [self addNewChatMessageData:dic];
    }
}
//更新阅读进度
- (void)updateReadingProgress
{
    CGFloat chatDataCount = [[NSString stringWithFormat:@"%lu",(unsigned long)self.chatModel.dataSource.count] floatValue];
    CGFloat allDataCount = [[NSString stringWithFormat:@"%lu",(unsigned long)self.allChatDataArray.count] floatValue];
    self.rateProgressView.progress = chatDataCount/allDataCount;
}
@end
