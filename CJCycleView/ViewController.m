//
//  ViewController.m
//  CJCycleView
//
//  Created by 耳东米青 on 2017/3/1.
//  Copyright © 2017年 耳东米青. All rights reserved.
//

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import "CJCycleScrollView.h"

@interface ViewController ()<CJCycleScrollViewDelegate>

@property (nonatomic, weak) CJCycleScrollView * cycleGoodView;
@property (nonatomic, strong) NSArray <NSNumber *>* contents;

@end

@implementation ViewController

- (NSArray *)contents
{
    if (!_contents) {
        _contents = @[@1,@2,@3,@4];
    }
    return _contents;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CJCycleScrollView * cycleGoodView = [[CJCycleScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 250)];
    //代理一定要在设置数据之前设置，因为在设置数据是创建内容需要代理中创建轮播视图
    cycleGoodView.delegate = self;
    //pageControl样式颜色
    cycleGoodView.curDotColor = [UIColor yellowColor];
    //设置距离底部的高度
    cycleGoodView.pagaControlHeight = 20;
    //数据
    cycleGoodView.itemArr = self.contents;
    //间隔时间
    cycleGoodView.pageTurnTime = 3;
    
    [self.view addSubview:cycleGoodView];
    self.cycleGoodView = cycleGoodView;
}

#pragma mark - CJCycleScrollViewDelegate

- (UIView *)cycleScrollView:(CJCycleScrollView *)cycleScrollView viewForItemAtIndex:(NSInteger)index withItems:(NSArray *)items
{
    //frame也可以不设置，但是如果你需要在其中加入其它控件，最好设置一下
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    
    NSNumber * num = items[index];
    //随机一个背景颜色
    label.backgroundColor = [UIColor colorWithRed:0.2 * num.floatValue green:0.01 * num.floatValue blue:0.2 * num.floatValue alpha:1];
    label.text = [NSString stringWithFormat:@"%@",num];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:100];
    
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
