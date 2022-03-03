//
//  UUInputFunctionView.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SparkInputFunctionView;

@protocol SparkInputFunctionViewDelegate <NSObject>

// text
- (void)SparkInputFunctionView:(SparkInputFunctionView *)funcView sendMessage:(NSString *)message;

// image
- (void)SparkInputFunctionView:(SparkInputFunctionView *)funcView sendPicture:(UIImage *)image;

// audio
- (void)SparkInputFunctionView:(SparkInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;

@end

@interface SparkInputFunctionView : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) UIButton *btnSendMessage;
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) UITextView *textViewInput;

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, assign) id<SparkInputFunctionViewDelegate>delegate;

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

@property(nonatomic,copy)void(^selRooterBlock)(NSString *typeName);

@end
