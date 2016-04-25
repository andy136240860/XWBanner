//
//  XWBannerViewCell.h
//  XWBanner
//
//  Created by 晓炜 郭 on 16/3/31.
//  Copyright © 2016年 晓炜 郭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface XWBannerViewCell : UIImageView

@property (nonatomic, strong) NSString *URL;

- (instancetype)initWithFrame:(CGRect)frame;

@end
