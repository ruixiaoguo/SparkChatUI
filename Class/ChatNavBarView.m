//
//  ChatNavBarView.m
//  UUChatTableView
//
//  Created by GRX on 2022/3/7.
//  Copyright © 2022 uyiuyao. All rights reserved.
//

#import "ChatNavBarView.h"
#define mainWindows [[[UIApplication sharedApplication] delegate]window]
#define isIphoneX mainWindows.safeAreaInsets.bottom>0
#define kNavigationBarHeight    (isIphoneX ? 68.f : 44.f)
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width

@implementation ChatNavBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.5;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    /** 返回按钮 */
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 25, 60, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    /** 标题 */
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, kNavigationBarHeight+24)];
    titleLable.text = @"Chapter1-Novel";
    titleLable.textColor = [UIColor blackColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:18];
    [self addSubview:titleLable];
}

-(void)backBtnClick{
    if (self.backBlock) {
        self.backBlock();
    }
}

@end
