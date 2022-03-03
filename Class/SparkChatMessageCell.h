//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparkMessageContentButton.h"
#define WeakSelf(weakSelf) __weak typeof(self) weakSelf = self

@class SparkChatMessageFrame;
@class SparkChatMessageCell;

@interface SparkChatMessageCell : UITableViewCell

@property (nonatomic, strong) SparkChatMessageFrame *messageFrame;

@property(nonatomic,copy)void(^selHeaderBlock)(NSString *headerName);

@property(nonatomic,copy)void(^cancleDataBlock)(void);

@end

