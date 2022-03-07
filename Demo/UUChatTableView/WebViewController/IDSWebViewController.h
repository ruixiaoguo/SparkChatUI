//
//  SetWebViewController.h
//  Spark
//
//  Created by GRX on 2021/9/22.
//

#import "SparkH5BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IDSWebViewController : SparkH5BaseController
@property(nonatomic,strong)NSString *navTitle;
@property(nonatomic,strong)NSString *webUrl;
@end

NS_ASSUME_NONNULL_END
