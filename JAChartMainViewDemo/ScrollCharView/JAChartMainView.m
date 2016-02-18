//
//  JAChartMainView.m
//
//  Created by jalyfeng@gmail.com on 16/1/29.
//  Copyright © 2016年 jalyfeng@gmail.com. All rights reserved.

#import "JAChartMainView.h"
#import "JAChartHandle.h"


#define yAsixMargin 30
#define ChartScrollRefreshHeaderWidth 50

typedef NS_ENUM(NSInteger,ChartScrollViewRefreshState) {
    ChartScrollViewRefreshStateNormal,
    ChartScrollViewRefreshStateRefreshing
};


@class JACharDataInterfaceView;

@interface JAChartMainView()<UIScrollViewDelegate>

@property(strong,nonatomic) UIView *refreshView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets edgeMarginInset;
@property (nonatomic, strong) JAChartHandle *handleChart;
@property (nonatomic,strong) JACharDataInterfaceView *charDataInterfaceView;
@property (nonatomic,assign)CGFloat yDetalValue;
@property (assign,nonatomic) ChartScrollViewRefreshState chartScrollViewRefreshState;

@end

@interface JACharDataInterfaceView : UIView



-(void)configureWithChartMainView:(JAChartMainView *)chartMainView;



@end

@implementation JAChartMainView{
    CGFloat yMaxValue;
    CGFloat xMaxValue;
    
}
@synthesize xAsixUnit,yAsixUnit,yDetalValue;


-(UIView *)refreshView{
    if(!_refreshView){
        _refreshView=[[UIView alloc]initWithFrame:CGRectMake(-54, 0, 54, CGRectGetHeight(self.frame))];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(34, 0, 20, CGRectGetHeight(_refreshView.bounds))];
        label.numberOfLines=0;
        label.text=@"滑动刷新";
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor redColor];
        label.tag=100;
        
        UIActivityIndicatorView *indicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center=CGPointMake(CGRectGetWidth(_refreshView.frame)/2, CGRectGetHeight(_refreshView.frame)/2);
        indicatorView.tag=101;
        indicatorView.hidden=YES;
        
        [_refreshView addSubview:indicatorView];
        [_refreshView addSubview:label];
    }
    return _refreshView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.bounces = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView = scrollView;
        _scrollView.delegate=self;
        [_scrollView insertSubview:self.refreshView atIndex:0];
        
        [self addSubview:scrollView];
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //初始化 表视图与父视图 的外围间距 上、左、下、右
        self.edgeMarginInset = UIEdgeInsetsMake(10, 40, 40, 10);
        
        if (!self.handleChart) {
            self.handleChart = [[JAChartHandle alloc] initWithChartCoordinateOrigin:CGPointMake(self.edgeMarginInset.left, self.frame.size.height-self.edgeMarginInset.bottom)];
        }
        self.handleChart.chartOriginPoint = CGPointMake(self.edgeMarginInset.left, self.frame.size.height-self.edgeMarginInset.bottom);
        
        CGRect frame=self.frame;
        CGFloat width=CGRectGetWidth(frame);
        CGFloat height=CGRectGetHeight(frame);
        yMaxValue=height-self.edgeMarginInset.top-self.edgeMarginInset.bottom;
        xMaxValue=width-self.edgeMarginInset.left-self.edgeMarginInset.right;
    }
    return self;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    UILabel *label=(UILabel *)[self.refreshView viewWithTag:100];
    label.hidden=YES;
    UIActivityIndicatorView *indicatorView=(UIActivityIndicatorView *)[self.refreshView viewWithTag:101];
    
    if(scrollView.contentOffset.x<-ChartScrollRefreshHeaderWidth){
        self.chartScrollViewRefreshState=ChartScrollViewRefreshStateRefreshing;
        scrollView.contentInset=UIEdgeInsetsMake(0, ChartScrollRefreshHeaderWidth, 0, 0);
        indicatorView.hidden=NO;
        [indicatorView startAnimating];
        scrollView.userInteractionEnabled=NO;
        [self.delegate chartMainViewDidRefresh:self];
    }else{
        self.chartScrollViewRefreshState=ChartScrollViewRefreshStateNormal;
        scrollView.contentInset=UIEdgeInsetsZero;
    }
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if(self.chartScrollViewRefreshState==ChartScrollViewRefreshStateRefreshing){
        return;
    }
    UILabel *label=(UILabel *)[self.refreshView viewWithTag:100];
    label.hidden=NO;
    
    UIActivityIndicatorView *indicatorView=(UIActivityIndicatorView *)[self.refreshView viewWithTag:101];
    [indicatorView stopAnimating];
    indicatorView.hidden=YES;
    
    if(scrollView.contentOffset.x<-ChartScrollRefreshHeaderWidth){
        label.text=@"松开刷新";
        
    }else{
        label.text=@"滑动刷新";
    }
}


#pragma mark -
-(void)endRefresh{
    self.scrollView.contentInset=UIEdgeInsetsZero;
    UIActivityIndicatorView *indicatorView=(UIActivityIndicatorView *)[self.refreshView viewWithTag:101];
    [indicatorView stopAnimating];
    indicatorView.hidden=YES;
    self.scrollView.userInteractionEnabled=YES;
    self.chartScrollViewRefreshState=ChartScrollViewRefreshStateNormal;
}
-(void)reloadData{
    NSAssert(xAsixUnit!=0, @"xAsixUnit is nil");
    NSAssert(yAsixUnit!=0, @"yAsixUnit is nil");
    NSInteger yAisxLabelArrayCount=[self.dataSource numberOfYAxisForChartMainView:self];
    NSInteger xAisxLabelArrayCount=[self.dataSource numberOfXAxisForChartMainView:self];
    yDetalValue=(yMaxValue-yAsixMargin)/(yAisxLabelArrayCount-1);
    self.scrollView.frame=CGRectMake(self.edgeMarginInset.left, 0, CGRectGetWidth(self.frame)-self.edgeMarginInset.left-self.edgeMarginInset.right, CGRectGetHeight(self.frame));
    
    CGFloat dataViewWidth=(xAisxLabelArrayCount+1)*xAsixUnit;
    
    if(!self.charDataInterfaceView){
        self.charDataInterfaceView=[[JACharDataInterfaceView alloc]init];
        self.charDataInterfaceView.backgroundColor=[UIColor clearColor];
        [self.scrollView addSubview:self.charDataInterfaceView];
    }
    self.charDataInterfaceView.frame=CGRectMake(0, 0, dataViewWidth, CGRectGetHeight(self.scrollView.bounds));
    self.scrollView.contentSize=CGSizeMake(dataViewWidth, CGRectGetHeight(self.scrollView.bounds));
    [self.charDataInterfaceView configureWithChartMainView:self];
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef drawCtx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(drawCtx, 1.0);
    CGContextSetStrokeColorWithColor(drawCtx, [UIColor blackColor].CGColor);
    CGContextSaveGState(drawCtx);
    
    
    //画y轴
    [self.handleChart drawALineWith:CGPointMake(0, 0) andEndPoint:CGPointMake(0, yMaxValue) andCtx:drawCtx andIsDash:NO andLineColor:[UIColor blackColor]];
    
    //画箭头
    [self.handleChart drawTriangleWith:CGPointMake(0, yMaxValue) andTextDirection:JAChartVerticalDirectionType andContext:drawCtx andArrowColor:[UIColor blackColor]];
    
    //画x轴
    [self.handleChart drawALineWith:CGPointMake(0, 0) andEndPoint:CGPointMake(xMaxValue, 0) andCtx:drawCtx andIsDash:NO andLineColor:[UIColor blackColor]];
    //画y轴坐标
    NSInteger yAisxLabelArrayCount=[self.dataSource numberOfYAxisForChartMainView:self];
    for(int i=0;i<yAisxLabelArrayCount;i++){
        [self.handleChart drawTextStringWith:CGPointMake(0, i*yDetalValue) andText:[self.dataSource chartMainView:self yAsixStringOfIndex:i] andDirection:JAChartValuePositionLeft andContext:drawCtx andTextColor:[UIColor magentaColor] andTextFont:[UIFont systemFontOfSize:12]];
        
        //画线
        [self.handleChart drawALineWith:CGPointMake(0, i*yDetalValue) andEndPoint:CGPointMake(xMaxValue, i*yDetalValue) andCtx:drawCtx andIsDash:NO andLineColor:[UIColor lightGrayColor]];
    }
    CGContextRestoreGState(drawCtx);
    
}


@end


@interface JACharDataInterfaceView()

@property(nonatomic,weak)JAChartMainView *chartMainView;

@property (nonatomic, assign) UIEdgeInsets edgeMarginInset;
@property (nonatomic, strong) JAChartHandle *handleChart;

@end


@implementation JACharDataInterfaceView{
    CGFloat yAsixDetalValue;
    CGFloat xAsixUnit;
    CGFloat yAsixUnit;
    UIBezierPath *bezierPath;
    CAShapeLayer *shapeLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)configureWithChartMainView:(JAChartMainView *)chartMainView{
    self.chartMainView=chartMainView;
    self.edgeMarginInset=self.chartMainView.edgeMarginInset;
    yAsixDetalValue=self.chartMainView.yDetalValue;
    xAsixUnit=self.chartMainView.xAsixUnit;
    yAsixUnit=self.chartMainView.yAsixUnit;
    if (!self.handleChart) {
        self.handleChart = [[JAChartHandle alloc] initWithChartCoordinateOrigin:CGPointMake(0, self.frame.size.height)];
    }
    if(!bezierPath){
        bezierPath=[UIBezierPath bezierPath];
        bezierPath.lineWidth = 1.0;
        
    }
    if(!shapeLayer){
        shapeLayer=[CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor redColor].CGColor;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    CGContextRef drawCtx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(drawCtx, 1.0);
    CGContextSetStrokeColorWithColor(drawCtx, [UIColor blackColor].CGColor);
    CGContextSaveGState(drawCtx);

    [shapeLayer removeFromSuperlayer];
    
    CGPoint prePoint;
    NSInteger xAsixArrayCount=[self.chartMainView.dataSource numberOfXAxisForChartMainView:self.chartMainView];
    for(int i=0;i<xAsixArrayCount;i++){
        NSString *xLabel=[self.chartMainView.dataSource chartMainView:self.chartMainView xAsixStringOfIndex:i];
        //画x坐标值
        [self.handleChart drawTextStringWith:CGPointMake((i+1)*xAsixUnit, self.edgeMarginInset.bottom) andText:xLabel andDirection:JAChartValuePositionDown andContext:drawCtx andTextColor:[UIColor blueColor] andTextFont:[UIFont systemFontOfSize:12]];
        CGFloat yValue=[self.chartMainView.dataSource chartMainView:self.chartMainView xyAsixValueOfIndex:i];
        CGFloat yAsixValue= (yValue/yAsixUnit)*yAsixDetalValue+self.edgeMarginInset.bottom;
        
    
        if(i!=0){
            //[self.handleChart drawALineWith:prePoint andEndPoint:CGPointMake((i+1)*xAsixUnit, yAsixValue) andCtx:drawCtx andIsDash:NO andLineColor:[UIColor greenColor]];
            if(i<xAsixArrayCount-2){
                CGFloat yValue1=[self.chartMainView.dataSource chartMainView:self.chartMainView xyAsixValueOfIndex:i+1];
                CGFloat yAsixValue1= (yValue1/yAsixUnit)*yAsixDetalValue+self.edgeMarginInset.bottom;

                CGFloat yValue2=[self.chartMainView.dataSource chartMainView:self.chartMainView xyAsixValueOfIndex:i+2];
                CGFloat yAsixValue2= (yValue2/yAsixUnit)*yAsixDetalValue+self.edgeMarginInset.bottom;

                
                [bezierPath addCurveToPoint:CGPointMake((i+1)*xAsixUnit, yAsixValue) controlPoint1:CGPointMake((i+2)*xAsixUnit, yAsixValue1) controlPoint2:CGPointMake((i+3)*xAsixUnit, yAsixValue2)];
            }else if(i==xAsixArrayCount-2){
                CGFloat yValue1=[self.chartMainView.dataSource chartMainView:self.chartMainView xyAsixValueOfIndex:i+1];
                CGFloat yAsixValue1= (yValue1/yAsixUnit)*yAsixDetalValue+self.edgeMarginInset.bottom;
                [bezierPath addQuadCurveToPoint:CGPointMake((i+1)*xAsixUnit, yAsixValue) controlPoint:CGPointMake((i+2)*xAsixUnit, yAsixValue1)];
            }
            
        }else{
            [bezierPath moveToPoint:CGPointMake((i+1)*xAsixUnit, yAsixValue)];
        }
        //画虚线
        [self.handleChart drawALineWith:CGPointMake((i+1)*xAsixUnit, yAsixValue) andEndPoint:CGPointMake((i+1)*xAsixUnit, self.edgeMarginInset.bottom) andCtx:drawCtx andIsDash:YES andLineColor:[UIColor lightGrayColor]];
        //画点
        [self.handleChart drawAPointWith:CGPointMake((i+1)*xAsixUnit, yAsixValue) andCtx:drawCtx andPointColor:[UIColor redColor]];
        //画点上数字
        [self.handleChart drawTextStringWith:CGPointMake((i+1)*xAsixUnit, yAsixValue) andText:[NSString stringWithFormat:@"%.2f",yValue] andDirection:JAChartValuePositionUp andContext:drawCtx andTextColor:[UIColor magentaColor] andTextFont:[UIFont systemFontOfSize:12]];
        
        
        prePoint=CGPointMake((i+1)*xAsixUnit, yAsixValue);
    }
    shapeLayer.path=bezierPath.CGPath;
    [self.layer addSublayer:shapeLayer];
    
    CGContextRestoreGState(drawCtx);
}

@end
