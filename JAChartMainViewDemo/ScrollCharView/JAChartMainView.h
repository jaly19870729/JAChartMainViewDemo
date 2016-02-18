//
//  JAChartMainView.h
//
//  Created by jalyfeng@gmail.com on 16/1/29.
//  Copyright © 2016年 jalyfeng@gmail.com. All rights reserved.

#import <UIKit/UIKit.h>

@class JAChartMainView;

@protocol JAChartMainViewDelegate <NSObject>

/**
 *  开始刷新
 *
 *  @param chartMainView <#chartMainView description#>
 */
-(void)chartMainViewDidRefresh:(JAChartMainView *)chartMainView;

@end

@protocol JAChartMainViewDatasource <NSObject>

/**
 *  Y轴数据个数
 *
 *  @param chartMainView <#chartMainView description#>
 */
-(NSInteger)numberOfYAxisForChartMainView:(JAChartMainView *)chartMainView;
/**
 *  y每个数据的值
 *
 *  @param chartMainView <#chartMainView description#>
 *  @param index        <#index description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)chartMainView:(JAChartMainView *)chartMainView yAsixStringOfIndex:(NSInteger)index;
/**
 *  X轴数据个数
 *
 *  @param chartMainView <#chartMainView description#>
 */
-(NSInteger)numberOfXAxisForChartMainView:(JAChartMainView *)chartMainView;
/**
 *  x每个数据的值
 *
 *  @param chartMainView <#chartMainView description#>
 *  @param index        <#index description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)chartMainView:(JAChartMainView *)chartMainView xAsixStringOfIndex:(NSInteger)index;
/**
 *  x轴上y的值
 *
 *  @param chartMainView <#chartMainView description#>
 *  @param index        <#index description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat )chartMainView:(JAChartMainView *)chartMainView xyAsixValueOfIndex:(NSInteger)index;

@end

@interface JAChartMainView : UIView

@property(weak,nonatomic) id<JAChartMainViewDatasource> dataSource;
@property(weak,nonatomic) id<JAChartMainViewDelegate> delegate;

@property(assign,nonatomic) CGFloat xAsixUnit;
@property(assign,nonatomic) CGFloat yAsixUnit;

-(void)reloadData;
-(void)endRefresh;

@end


