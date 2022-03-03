//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SparkChatMessageFrame;
@interface SparkChatModel : NSObject

@property (nonatomic, strong) NSMutableArray<SparkChatMessageFrame *> *dataSource;

- (void)addLeetMeItem:(NSDictionary *)dic;

- (void)addLeetOtherItem:(NSDictionary *)dic;

- (void)addLeetNarratorItem:(NSDictionary *)dic;

- (void)recountFrame;

@end
