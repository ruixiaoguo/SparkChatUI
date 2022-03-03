//
//  UUInputToolsView.h
//  UUChatTableView
//
//  Created by GRX on 2022/3/3.
//  Copyright © 2022 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SparkInputToolsView : UIView

@property(nonatomic,copy)void(^selTypeBlock)(NSString *typeName);

@end

NS_ASSUME_NONNULL_END
