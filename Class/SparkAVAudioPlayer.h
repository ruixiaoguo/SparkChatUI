#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol SparkAVAudioPlayerDelegate <NSObject>

- (void)SparkAVAudioPlayerBeiginLoadVoice;

- (void)SparkAVAudioPlayerBeiginPlay;

- (void)SparkAVAudioPlayerDidFinishPlay;

@end

@interface SparkAVAudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, weak) id<SparkAVAudioPlayerDelegate> delegate;

+ (instancetype)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;

-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;

@end
