//
//  ChatNavBarView.h
//  UUChatTableView
//
//  Created by GRX on 2022/3/7.
//  Copyright © 2022 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatNavBarView : UIView
@property(nonatomic,strong)void(^backBlock)(void);

@end

NS_ASSUME_NONNULL_END
