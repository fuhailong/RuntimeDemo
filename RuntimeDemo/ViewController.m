//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 付海龙 on 2019/3/19.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+Test.h"
#import "DataItem.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.abc = @"测试";
    
    //动态添加方法
    [label performSelector:@selector(test:) withObject:@"test"];
    
    NSDictionary *dict = @{
                           @"name":@"fuhailong",
                           @"tel":@8888888,
                           @"sex":@"男",
                           @"list":@[
                                   @{@"name":@"fu"},
                                   @{@"name":@"hai"},
                                   @{@"name":@"long"}
                                   ]
                           };
    
    DataItem *item = [DataItem toItem:dict];
    NSLog(@"name : %@, class : %@", item.name, NSStringFromClass([item.name class]));
    NSLog(@"tel : %@, tel : %@", item.tel, NSStringFromClass([item.tel class]));
    NSLog(@"list->name : %@", ((DataItem *)item.list.firstObject).name);
}

@end
