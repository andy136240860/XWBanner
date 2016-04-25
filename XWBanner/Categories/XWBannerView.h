//
//  XWBanner.h
//  XWBanner
//
//  Created by 晓炜 郭 on 16/3/31.
//  Copyright © 2016年 晓炜 郭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWPageControl.h"
#import "XWBannerViewCell.h"

@class XWBannerView;

@protocol XWBannerViewDataSource <NSObject>
@required
- (NSInteger)numberOfCellInView:(XWBannerView *)bannerView;
- (XWBannerViewCell *)XWBannerView:(XWBannerView *)bannerView cellForIndex:(NSInteger)index;
@end

@protocol XWBannerViewDelegate <NSObject>
@optional
- (void)XWBannerView:(XWBannerView *)bannerView didSelectAtIndex:(NSInteger)index;

@end


@interface XWBannerView : UIView <UIScrollViewDelegate>

@property (nonatomic, retain) id <XWBannerViewDataSource> dataSource;
@property (nonatomic, retain) id <XWBannerViewDelegate> delegate;

@property (strong,nonatomic) XWPageControl      *pageControl;  //pageControl，可自定义小圆点样式
@property (assign,nonatomic) NSInteger          currentPage;
@property (nonatomic) BOOL                      hasPageControl;  //是否需要小圆点，默认YES
@property (nonatomic) BOOL                      autoScroll;  //是否要自动播放，默认YES
@property (assign,nonatomic) float              scrollTime;           //滚动间隔，默认5

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadData;

@end



