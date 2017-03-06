//
//  CJCycleScrollView.m
//  XY
//
//  Created by 耳东米青 on 16/10/20.
//  Copyright © 2016年 XY. All rights reserved.
//

#import "CJCycleScrollView.h"

#define kSelfWidth self.frame.size.width
#define kSelfHeight self.frame.size.height

@interface CJCycleScrollView ()<UIScrollViewDelegate>

/*滑动试图*/
@property (strong, nonatomic) UIScrollView * scrollView;

/*定时器*/
@property (strong, nonatomic) NSTimer * timer;

/*是否允许定时器运行*/
@property (assign, nonatomic) BOOL timingMove;

/*页码指示器*/
@property (nonatomic, weak) UIPageControl * pageControl;

/*数据*/
@property (nonatomic, strong) NSArray * items;

@end

@implementation CJCycleScrollView

- (NSArray *)items
{
    if (!_items) {
        _items = [NSArray array];
    }
    return _items;
}

/*初始化*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatScrollView];
        
        [self createPageControl];
    }
    return self;
}

/*创建滑动视图*/
- (void)creatScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    [self addSubview:self.scrollView];
}

/*创建pageControl*/
- (void)createPageControl
{
    UIPageControl * pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kSelfHeight - 30, kSelfWidth, 120)];
    pageControl.hidesForSinglePage = YES;
    
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark - 设置数据源

- (void)setItemArr:(NSArray *)itemArr
{
    _itemArr = itemArr;
    
    self.items = [[self addFirstAndLastItem:itemArr] copy];
    
    //创建真实页面内数据
    if (self.items.count > 0) {
        [self createScrollViewData:self.items];
    }
}

/*数组的首尾添加图片，在首位各添加一张图片的数组（尾添加到首，首添加到尾）*/
- (NSArray *)addFirstAndLastItem:(NSArray *)array {
    // 设置成(5个为例子):5.1.2.3.4.5.1
    NSMutableArray * mutableItems = [array mutableCopy];
    // 获取数组中的第一张图片
    id firstItem = [array firstObject];
    // 获取数组中的第二张图片
    id lastItem = [array lastObject];
    // 添加第一张图片到最后的位置
    if (firstItem) {
        [mutableItems insertObject:firstItem atIndex:mutableItems.count];
    }
    // 添加最后一张图片到第一的位置
    if (lastItem) {
        [mutableItems insertObject:lastItem atIndex:0];
    }
    
    return mutableItems;
}

/*为滑动试图设置数据*/
- (void)createScrollViewData:(NSArray *)items {
    // 设置滑动视图的实际尺寸
    self.scrollView.contentSize = CGSizeMake(kSelfWidth * items.count, kSelfHeight);
    // 设置滑动视图的偏移量到第一页
    self.scrollView.contentOffset = CGPointMake(kSelfWidth, 0);
    for (int i = 0; i < items.count; i ++) {
        
        //添加scrollview的content
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForItemAtIndex:withItems:)]) {
            //根据代理获取内容
            UIView * subView = [self.delegate cycleScrollView:self viewForItemAtIndex:i withItems:items];
            subView.frame = CGRectMake(i * kSelfWidth, 0, kSelfWidth, kSelfHeight);
            //添加点击手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewBtnAction)];
            [subView addGestureRecognizer:tap];
            
            [self.scrollView addSubview:subView];
        }
    }
    // 设置分页控件的页数
    self.pageControl.numberOfPages = self.items.count - 2;
}

/*按钮点击事件-通知代理*/
- (void)imgViewBtnAction
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:self.pageControl.currentPage];
    }
}

#pragma mark - 设置属性
- (void)setCurDotColor:(UIColor *)curDotColor
{
    _curDotColor = curDotColor;
    self.pageControl.currentPageIndicatorTintColor = curDotColor;
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    self.pageControl.pageIndicatorTintColor = dotColor;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.scrollView.scrollEnabled = scrollEnabled;
}

#pragma mark - 设置翻页时间并开启定时器
- (void)setPageTurnTime:(CGFloat)pageTurnTime {
    _pageTurnTime = pageTurnTime;
    
    [self addTimer];
    
    // 设置可以定时器开始
    self.timingMove = YES;
}

/*添加定时器*/
- (void)addTimer{
    self.timer = [NSTimer timerWithTimeInterval:self.pageTurnTime target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    // 设置RunLoop模式，保证页面滑动的时候定时器仍然运行
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/*切换到下一张图片*/
- (void)nextImage{
    // 计算scrollView滚动的位置
    CGFloat offsetX = self.scrollView.contentOffset.x + kSelfWidth;
    [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/*移除定时器*/
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UIScrollViewDelegate

/*在手指已经开始拖住的时候移除定时器*/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        [self removeTimer];
    }
}

/*在手指已经停止拖住的时候添加定时器*/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_timer == nil && _timingMove) {
        [self addTimer];
    }
}

/*当滑动试图停止减速（停止）调用（用于手动拖拽*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updatePageCtrlWithContentOffset:scrollView.contentOffset.x];
}


/*当滑动试图停止减速调用（用于定时器）*/
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self updatePageCtrlWithContentOffset:scrollView.contentOffset.x];
}

#pragma mark - 更新PageControl的当前页

- (void)updatePageCtrlWithContentOffset:(CGFloat)contentOffset_x
{
    // 一定要用float类型，非常重要
    CGFloat index = contentOffset_x / (kSelfWidth) ;
    
    if (index >= self.items.count - 1) {//滑到最后一个（表面是第一个）
        
        //设置视图的偏移量到第二个
        self.scrollView.contentOffset = CGPointMake(kSelfWidth, 0);
        [self setPageContrlCurrentPage:0];
        
    } else if(index <= 0){//滑到第一个（表面是最后一个）
        
        self.scrollView.contentOffset = CGPointMake((self.items.count - 2) *kSelfWidth, 0);
        [self setPageContrlCurrentPage:self.items.count - 3];
        
    } else {//设置self.pageControl显示的页数（减去第一个）
        
        [self setPageContrlCurrentPage:index - 1];
    }
}

/*设置PageControl的当前页*/
- (void)setPageContrlCurrentPage:(NSInteger)currentPage {
    self.pageControl.currentPage = currentPage;
    //代理通知滚动到第几页
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:currentPage];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置pageControl的位置
    self.pageControl.frame = CGRectMake(0, self.pagaControlHeight > 0 ? (kSelfHeight -  self.pagaControlHeight - 20) : kSelfHeight - 30, kSelfWidth, 20);
}

@end
