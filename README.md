# CJCycleScrollView

###自定义内容、不复用的轮播图
pod导入
pod 'CJCycleScrollView'
也可以下载之后直接拖入项目中

可以自定义轮播的内容，对于下面这种情况比较适用：

![CJCycleScrollView.png](http://upload-images.jianshu.io/upload_images/1825076-e7d766ff37fad448.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




#####使用方法
```
//创建CJCycleScrollView
- (void)createCycleScrollView
{
    CJCycleScrollView * cycleGoodView = [[CJCycleScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 250)];
    //代理一定要在设置数据之前设置，因为在设置数据是创建内容需要代理中创建轮播视图
    cycleGoodView.delegate = self;
    //pageControl样式颜色
    cycleGoodView.curDotColor = [UIColor lightGrayColor];
    //设置距离底部的高度
    cycleGoodView.pagaControlHeight = 20;
    //数据
    cycleGoodView.itemArr = self.contents;
    //间隔时间
    cycleGoodView.pageTurnTime = 3;

    [self.view addSubview:cycleGoodView];
    self.cycleGoodView = cycleGoodView;
}

//自定义内容
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
```



