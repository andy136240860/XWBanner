//
//  XWBanner.m
//  XWBanner
//
//  Created by 晓炜 郭 on 16/3/31.
//  Copyright © 2016年 晓炜 郭. All rights reserved.
//

#import "XWBannerView.h"

@protocol XWBannerScrollViewDelegate <NSObject>

- (void) touchesBegan;
- (void) touchesEnded;

@end

@interface XWBannerScrollView : UIScrollView

@property (weak, nonatomic) id<XWBannerScrollViewDelegate> XWdelegate;

@end

@implementation XWBannerScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan....");
    if (self.XWdelegate) {
        [self.XWdelegate touchesBegan];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded....");
    if (self.XWdelegate) {
        [self.XWdelegate touchesEnded];
    }
}

@end

@interface XWBannerView()<XWBannerScrollViewDelegate>{
    XWBannerScrollView    *_contentScrollView;
    NSInteger       numberOfCell;
    UIView          *_preView;  //preView       之前的View
    UIView          *_curView;  //currentView   当前的View
    UIView          *_posView;  //posteriorView 后面的第三个View
    NSTimer         *_timer;
    
    BOOL            _itemsSubviewsCacheIsValid;
    NSArray         *_itemSubviewsCache;
}

@end

@implementation XWBannerView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hasPageControl = YES;
        self.autoScroll = YES;
        self.scrollTime = 2.5;
        [self initSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hasPageControl = YES;
        self.autoScroll = YES;
        self.scrollTime = 2.5;
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    _contentScrollView = [[XWBannerScrollView alloc]initWithFrame:self.bounds];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.XWdelegate = self;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.bounces = NO;
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    [_contentScrollView addGestureRecognizer:singleRecognizer];
    [self addSubview:_contentScrollView];
    
    [self addPageControlToSuperView];
}

- (void)addPageControlToSuperView{
    if (_pageControl) {
        return;
    }
    _pageControl = [[XWPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 30)];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

- (void)handleSingleTapFrom:(UISwipeGestureRecognizer*)recognizer{
    if ([self.delegate respondsToSelector:@selector(XWBannerView:didSelectAtIndex:)]) {
        [self.delegate XWBannerView:self didSelectAtIndex:self.currentPage];
    }
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    if (autoScroll) {
        [self startTimer];
    }
    else{
        [self stopTimer];
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _contentScrollView.frame = self.bounds;
    _preView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _curView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    _posView.frame = CGRectMake(self.bounds.size.width*2,0 , self.bounds.size.width, self.bounds.size.height);
    _pageControl.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 30);
    [self reloadScrollView];
    [self resetData];
}

- (void)reloadData{
    self.currentPage = 0;
    for (UIView * v in [self subviews]){
        if ([v isKindOfClass:[XWBannerViewCell class]]){
            [v removeFromSuperview];
        }
    }
    _itemsSubviewsCacheIsValid = NO;
    _itemSubviewsCache = nil;
    [self reloadScrollView];
    [self resetData];
}

- (void)didMoveToSuperview{
    [self reloadScrollView];
    [self resetData];
}

#pragma mark - Data

- (NSInteger)preIndex{
    NSInteger index = self.currentPage - 1;
    if (index < 0) {
        return index + numberOfCell;
    }
    else return index;
}

- (NSInteger)curIndex{
    return self.currentPage;
}

- (NSInteger)posIndex{
    NSInteger index = self.currentPage + 1;
    if (index == numberOfCell) {
        return 0;
    }
    else return index;
}

- (void)resetData{
    if (numberOfCell > 1) {
        if([self cellForItemAtIndex:[self preIndex]]){
            [_preView addSubview:[self cellForItemAtIndex:[self preIndex]]];
            [_contentScrollView bringSubviewToFront:[self cellForItemAtIndex:[self preIndex]]];
        }
        else{
            [_preView addSubview:[self.dataSource XWBannerView:self cellForIndex:[self preIndex]]];
            _itemsSubviewsCacheIsValid = NO;
        }
        if([self cellForItemAtIndex:[self curIndex]]){
            [_curView addSubview:[self cellForItemAtIndex:[self curIndex]]];
            [_contentScrollView bringSubviewToFront:[self cellForItemAtIndex:[self curIndex]]];
        }
        else{
            [_curView addSubview:[self.dataSource XWBannerView:self cellForIndex:[self curIndex]]];
            _itemsSubviewsCacheIsValid = NO;
        }
        if([self cellForItemAtIndex:[self posIndex]]){
            [_posView addSubview:[self cellForItemAtIndex:[self posIndex]]];
            [_contentScrollView bringSubviewToFront:[self cellForItemAtIndex:[self posIndex]]];
        }
        else{
            [_posView addSubview:[self.dataSource XWBannerView:self cellForIndex:[self posIndex]]];
            _itemsSubviewsCacheIsValid = NO;
        }
    }
    else{
        if (numberOfCell) {
            if([self cellForItemAtIndex:[self curIndex]]){
                [_preView addSubview:[self cellForItemAtIndex:[self curIndex]]];
                [_contentScrollView bringSubviewToFront:[self cellForItemAtIndex:[self curIndex]]];
            }
            else{
                [_preView addSubview:[self.dataSource XWBannerView:self cellForIndex:[self curIndex]]];
                _itemsSubviewsCacheIsValid = NO;
            }
        }
    }
    _pageControl.currentPage = _currentPage;
}

- (void)goForNextPage{
    [_contentScrollView setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.currentPage = [self posIndex];
    [_contentScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    [self resetData];
    [self startTimer];
    _pageControl.currentPage = self.currentPage;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _contentScrollView) {
        if (_contentScrollView.contentOffset.x == 0) {
            self.currentPage = [self preIndex];
            [_contentScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
            [self resetData];
        }
        if (_contentScrollView.contentOffset.x == self.frame.size.width * 2) {
            self.currentPage = [self posIndex];
            [_contentScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
            [self resetData];
        }
        [self startTimer];
    }
    _pageControl.currentPage = self.currentPage;
}

#pragma mark private methods

- (XWBannerViewCell *)cellForItemAtIndex:(NSInteger)index{
    XWBannerViewCell *view = nil;
    for (XWBannerViewCell *v in [self itemSubviews]){
        if (v.tag == index){
            view = v;
            break;
        }
    }
    return view;
}

- (NSArray *)itemSubviews
{
    NSArray *subviews = nil;
    if (_itemsSubviewsCacheIsValid){
        subviews = [_itemSubviewsCache copy];
    }
    else{
        @synchronized(self)
        {
            NSMutableArray *itemSubViews = [[NSMutableArray alloc] initWithCapacity:numberOfCell];
            
            for (UIView * v in [self subviews]){
                if ([v isKindOfClass:[XWBannerViewCell class]]){
                    [itemSubViews addObject:v];
                }
            }
            subviews = itemSubViews;
            _itemSubviewsCache = [subviews copy];
            _itemsSubviewsCacheIsValid = YES;
        }
    }
    
    return subviews;
}

- (void)reloadScrollView{
    numberOfCell = [self.dataSource numberOfCellInView:self];
    [_preView removeFromSuperview];
    _preView = nil;
    [_curView removeFromSuperview];
    _curView = nil;
    [_posView removeFromSuperview];
    _posView = nil;
    if (numberOfCell > 1) {
        _contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3,self.frame.size.height);
        [_contentScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        _preView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _preView.clipsToBounds = YES;
        _curView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        _curView.clipsToBounds = YES;
        _posView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, self.frame.size.height)];
        _posView.clipsToBounds = YES;
        [_contentScrollView addSubview:_preView];
        [_contentScrollView addSubview:_curView];
        [_contentScrollView addSubview:_posView];
        [self addPageControlToSuperView];
        [self startTimer];
    }
    else{
        _contentScrollView.contentSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
        [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        _preView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _preView.clipsToBounds = YES;
        [_contentScrollView addSubview:_preView];
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    _pageControl.numberOfPages = numberOfCell;
    self.pageControl.hidden = !_hasPageControl;
}

#pragma mark - pageControl

- (void)setHasPageControl:(BOOL)hasPageControl{
    _hasPageControl = hasPageControl;
    self.pageControl.hidden = !_hasPageControl;
}


#pragma mark - XWScrollViewDelegate

- (void)touchesBegan{
    [self stopTimer];
}

- (void)touchesEnded{
    if (numberOfCell > 1) {
        [self startTimer];
    }
}

- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)startTimer{
    if (self.autoScroll) {
        if (_timer) {
            return;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTime target:self selector:@selector(goForNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

@end
