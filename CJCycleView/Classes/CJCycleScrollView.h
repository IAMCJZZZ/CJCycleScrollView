//
//  CJCycleScrollView.h
//  XY
//
//  Created by 耳东米青 on 16/10/20.
//  Copyright © 2016年 XY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJCycleScrollView;

@protocol CJCycleScrollViewDelegate <NSObject>

/**
 content

 @param index 添加后的页码数
 @param items 数据源
 @return 页内的内容
 */
- (UIView *)cycleScrollView:(CJCycleScrollView *)cycleScrollView viewForItemAtIndex:(NSInteger)index withItems:(NSArray *)items;

@optional
/**
 点击页面后调用

 @param index 点击的页码
 */
- (void)cycleScrollView:(CJCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/**
 页面已经发生改变时调用
 
 @param index 滚动到的页码
 */
- (void)cycleScrollView:(CJCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface CJCycleScrollView : UIView

//代理
@property (nonatomic, weak) id <CJCycleScrollViewDelegate> delegate;

/** 数据源*/
@property (strong, nonatomic) NSArray * itemArr;

/** 翻页时间间隔(不设置不能滑动)*/
@property (nonatomic, assign) CGFloat pageTurnTime;

/** 页码指示器圆标颜色 */
@property (nonatomic, strong) UIColor *dotColor;

/** 页码指示器当前页圆标颜色 */
@property (nonatomic, strong) UIColor *curDotColor;

/** 页码指示器和底部的距离 */
@property (nonatomic, assign) CGFloat pagaControlHeight;

/** 是否允许滑动 */
@property (nonatomic, assign) BOOL scrollEnabled;

@end





