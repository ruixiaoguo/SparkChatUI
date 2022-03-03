//
//  UUMessageFrame.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "SparkChatMessageFrame.h"
#import "SparkChatMessage.h"
#import "SparkChatCategory.h"

@implementation SparkChatMessageFrame

- (void)setMessage:(SparkChatMessage *)message{
    
    _message = message;
    
    CGFloat const screenW = [UIScreen uu_screenWidth];
    
    // 1、计算时间的位置
    if (_showTime){
		CGSize timeSize = [_message.strTime uu_sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100)];
        _timeF = CGRectMake((screenW - timeSize.width) / 2, ChatMargin, timeSize.width, timeSize.height);
    } else {
		_timeF = CGRectZero;
	}
    
    // 2、计算头像位置
    CGFloat const iconX = _message.from == UUMessageFromMe ?(screenW - ChatMargin - ChatIconWH):ChatMargin;
    _iconF = CGRectMake(iconX, CGRectGetMaxY(_timeF) + ChatMargin, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
	CGSize nameSize = [_message.strName uu_sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(ChatIconWH+ChatMargin, 50)];
    _nameF = CGRectMake(iconX-ChatMargin/2.0, CGRectGetMaxY(_iconF) + ChatMargin/2.0, ChatIconWH+ChatMargin, nameSize.height);
    
    // 4、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) + ChatMargin;
   
    //根据种类分
    CGSize contentSize;
    switch (_message.type) {
        case UUMessageTypeText:
			contentSize = [_message.strContent uu_sizeWithFont:ChatContentFont constrainedToSize:CGSizeMake(MAX(Main_Screen_Width-150, screenW*0.6), CGFLOAT_MAX)];
            if (_message.from == UUMessageFromNarrator) {
                contentSize = CGSizeMake(Main_Screen_Width-150, contentSize.height);
            }
			contentSize.height = MAX(contentSize.height, 30);
			contentSize.width = MAX(contentSize.width, 40);
            break;
        case UUMessageTypePicture:
            contentSize = CGSizeMake(Main_Screen_Width-150, ChatPicWH);
            break;
        case UUMessageTypeVoice:
            contentSize = CGSizeMake(150, 35);
            break;
        default:
            break;
    }
    if (_message.from == UUMessageFromMe) {
        contentX = screenW - (contentSize.width + ChatContentBiger + ChatContentSmaller + ChatMargin + ChatIconWH + ChatMargin);
    }
    _contentF = CGRectMake(contentX, CGRectGetMinY(_iconF) + 5, contentSize.width + ChatContentBiger + ChatContentSmaller, contentSize.height + ChatContentTopBottom * 2);
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + ChatMargin;
}

- (void)setShowTime:(BOOL)showTime
{
	_showTime = showTime;
	
	if (_message) {
		self.message = _message;
	}
}

@end
