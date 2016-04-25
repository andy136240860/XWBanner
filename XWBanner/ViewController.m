//
//  ViewController.m
//  XWBanner
//
//  Created by 晓炜 郭 on 16/3/31.
//  Copyright © 2016年 晓炜 郭. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<XWBannerViewDataSource,XWBannerViewDelegate>{
    UIView *view;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XWBannerView *banner = [[XWBannerView alloc]init];
    banner.frame = CGRectMake(0 , 200, [UIScreen mainScreen].bounds.size.width, 120);
    banner.delegate = self;
    banner.dataSource = self;
    banner.scrollTime = 3;
    banner.autoScroll = YES;
    banner.hasPageControl = YES;
    banner.currentPage = 3;
    [self.view addSubview:banner];
 

}

- (NSInteger)numberOfCellInView:(XWBannerView *)bannerView{
    return 5;
}

- (XWBannerViewCell *)XWBannerView:(XWBannerView *)bannerView cellForIndex:(NSInteger)index{
    XWBannerViewCell *cell = [[XWBannerViewCell alloc]initWithFrame:CGRectMake(0 , 0 , [UIScreen mainScreen].bounds.size.width, 240)];
    switch (index) {
        case 0:
            cell.backgroundColor = [UIColor blueColor];
//            cell.URL =@"https://o1wjx1evz.qnssl.com/app/qrcode/AVQK";
            break;
        case 1:
            cell.backgroundColor = [UIColor blackColor];
            cell.URL =@"http://pic.to8to.com/attch/day_160218/20160218_6410eaeeba9bc1b3e944xD5gKKhPEuEv.png";
            break;
        case 2:
            cell.backgroundColor = [UIColor purpleColor];
            cell.URL =@"http://img02.tooopen.com/images/20160216/tooopen_sy_156324542564.jpg";
            break;
        case 3:
            cell.backgroundColor = [UIColor redColor];
            cell.URL =@"http://pic32.nipic.com/20130829/12906030_124355855000_2.png";
            break;
        case 4:
            cell.backgroundColor = [UIColor greenColor];
            cell.URL =@"http://www.52ij.com/uploads/allimg/160317/003T95164-3.jpg";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)XWBannerView:(XWBannerView *)bannerView didSelectAtIndex:(NSInteger)index{
    NSLog(@"点击图片第%d个",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
