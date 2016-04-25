//
//  XWBannerViewCell.m
//  XWBanner
//
//  Created by 晓炜 郭 on 16/3/31.
//  Copyright © 2016年 晓炜 郭. All rights reserved.
//

#import "XWBannerViewCell.h"

@implementation XWBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{

}

- (void)setURL:(NSString *)URL{
    _URL = URL;
    [self sd_setImageWithURL:[NSURL URLWithString:_URL]];
}

@end
