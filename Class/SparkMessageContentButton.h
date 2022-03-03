//
//  SparkMessageContentButton.h
//  UUChatTableView
//
//  Created by GRX on 2022/3/3.
//  Copyright © 2022 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SparkMessageContentButton : UIButton

@property (nonatomic, retain) UIImageView *backImageView;
@property (nonatomic, retain) UIView *voiceBackView;
@property (nonatomic, retain) UILabel *second;
@property (nonatomic, retain) UIImageView *voice;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) BOOL isMyMessage;

- (void)benginLoadVoice;
- (void)didLoadVoice;
-(void)stopPlay;

@end

NS_ASSUME_NONNULL_END
