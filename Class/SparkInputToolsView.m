//
//  UUInputToolsView.m
//  UUChatTableView
//
//  Created by GRX on 2022/3/3.
//  Copyright © 2022 uyiuyao. All rights reserved.
//

#import "SparkInputToolsView.h"

@implementation SparkInputToolsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    NSArray *tArray = @[@"Me",@"Other",@"Nator"];
    for (int i=0; i<3; i++) {
        UIButton *rooteBtn = [[UIButton alloc]init];
        [rooteBtn setTitle:tArray[i] forState:UIControlStateNormal];
        rooteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rooteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rooteBtn setBackgroundColor:[UIColor lightGrayColor]];
        rooteBtn.layer.cornerRadius = 20;
        rooteBtn.frame = CGRectMake(100+i*90, 5, 40, 40);
        [rooteBtn addTarget:self action:@selector(rooteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        rooteBtn.tag = i+10;
        [self addSubview:rooteBtn];
        if (i==0) {
            [rooteBtn setBackgroundColor:[UIColor redColor]];
            [rooteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

-(void)rooteBtnClick:(UIButton *)sender{
    for (int i=0; i<3; i++) {
        UIButton *rooteBtn = [(UIButton *)self viewWithTag:i+10];
        [rooteBtn setBackgroundColor:[UIColor lightGrayColor]];
        [rooteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [sender setBackgroundColor:[UIColor redColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.selTypeBlock) {
        self.selTypeBlock(sender.currentTitle);
    }
}

@end
