//
//  ViewController.m
//  JAChartMainViewDemo
//
//  Created by jalyfeng@gmail.com on 16/1/29.
//  Copyright © 2016年 jalyfeng@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "JAChartMainView.h"

@interface ViewController ()<JAChartMainViewDatasource,JAChartMainViewDelegate>

@property (nonatomic,strong) JAChartMainView *chartMainView;
@property (strong,nonatomic) NSArray *yAisxLabelArray;
@property (strong,nonatomic) NSMutableArray *xAisxLabelArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    
    [self addJACharView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addJACharView{
    self.yAisxLabelArray=@[@"0",@"10",@"20",@"30",@"40"];
    self.xAisxLabelArray=[NSMutableArray arrayWithArray:@[@{@"x":@"一",@"y":@(10.1)},
                                                          @{@"x":@"二",@"y":@(8.1)},
                                                          @{@"x":@"三",@"y":@(30.1)},
                                                          @{@"x":@"四",@"y":@(21.1)},
                                                          @{@"x":@"五",@"y":@(29.1)},
                                                          @{@"x":@"六",@"y":@(18.1)},
                                                          @{@"x":@"七",@"y":@(27.1)},
                                                          @{@"x":@"八",@"y":@(36.1)},
                                                          @{@"x":@"九",@"y":@(21.1)},
                                                          @{@"x":@"十",@"y":@(16.1)},
                                                          @{@"x":@"十一",@"y":@(33.1)},
                                                          @{@"x":@"十二",@"y":@(13.1)},
                                                          @{@"x":@"十三",@"y":@(26.1)},
                                                          @{@"x":@"十四",@"y":@(32.1)},
                                                          @{@"x":@"十五",@"y":@(27.1)},
                                                          
                                                          ]];
    
    
    self.chartMainView=[[JAChartMainView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    self.chartMainView.backgroundColor=[UIColor whiteColor];
    self.chartMainView.xAsixUnit=50;
    self.chartMainView.yAsixUnit=10;
    self.chartMainView.dataSource=self;
    self.chartMainView.delegate=self;
    
    [self.view addSubview:self.chartMainView];
    [self.chartMainView reloadData];
}

#pragma mark -
#pragma mark JAChartMainViewDelegate

-(void)chartMainViewDidRefresh:(JAChartMainView *)chartMainView{
    [self.xAisxLabelArray insertObject:@{@"x":@"①",@"y":@(32.0)} atIndex:0];
    [self.xAisxLabelArray insertObject:@{@"x":@"②",@"y":@(22.0)} atIndex:0];
    [self.xAisxLabelArray insertObject:@{@"x":@"③",@"y":@(34.0)} atIndex:0];
    [self.xAisxLabelArray insertObject:@{@"x":@"④",@"y":@(17.0)} atIndex:0];
    [self.xAisxLabelArray insertObject:@{@"x":@"⑤",@"y":@(26.0)} atIndex:0];
    [self.xAisxLabelArray insertObject:@{@"x":@"⑥",@"y":@(33.0)} atIndex:0];
    [self.xAisxLabelArray insertObject:@{@"x":@"⑦",@"y":@(12.0)} atIndex:0];
    [self.xAisxLabelArray insertObject:@{@"x":@"⑧",@"y":@(22.0)} atIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chartMainView endRefresh];
            [self.chartMainView reloadData];
        });
    });
}

#pragma mark -
#pragma mark JAChartMainViewDatasource

-(NSInteger)numberOfYAxisForChartMainView:(JAChartMainView *)chartMainView{
    return self.yAisxLabelArray.count;
}

-(NSString *)chartMainView:(JAChartMainView *)chartMainView yAsixStringOfIndex:(NSInteger)index{
    return self.yAisxLabelArray[index];
}

-(NSInteger)numberOfXAxisForChartMainView:(JAChartMainView *)chartMainView{
    return self.xAisxLabelArray.count;
}

-(NSString *)chartMainView:(JAChartMainView *)chartMainView xAsixStringOfIndex:(NSInteger)index{
    return [self.xAisxLabelArray[index] objectForKey:@"x"];
}

-(CGFloat )chartMainView:(JAChartMainView *)chartMainView xyAsixValueOfIndex:(NSInteger)index{
    return [[self.xAisxLabelArray[index] valueForKey:@"y"] floatValue];
}


#pragma mark -

@end