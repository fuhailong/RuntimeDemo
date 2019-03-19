//
//  DataItem.m
//  RuntimeDemo
//
//  Created by 付海龙 on 2019/3/19.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "DataItem.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation DataItem

+ (NSDictionary *)arrayPropertyGenericClass
{
    return @{
             @"list":[DataItem class]
             };
}

+ (id)toItem:(NSDictionary *)dict {
    
    Class class = objc_msgSend(objc_msgSend([self class], @selector(alloc)), @selector(init));
    
    NSDictionary *classDict = [DataItem arrayPropertyGenericClass];
    
    //成员变量个数
    unsigned int outCount = 0;
    
    //获取DataItem所有成员变量数组
    Ivar *ivarList = class_copyIvarList(self, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        //将成员变量从list中取出
        Ivar oneIvar = ivarList[i];
        
        //转换成NSString, 转换后的成员变量名字前面都带有 “_”
        NSString *oneIvarStr = [NSString stringWithUTF8String:ivar_getName(oneIvar)];
        
        //去掉 _
        oneIvarStr = [oneIvarStr substringFromIndex:1];
        
        //从字典中取出对应的value
        id value = dict[oneIvarStr];
        
        if ([classDict.allKeys containsObject:oneIvarStr]) {
            //这个是array类型
            Class subClass = classDict[oneIvarStr];
            NSArray *valueArray = (NSArray *)value;
            __block NSMutableArray *newMutList = [NSMutableArray arrayWithCapacity:outCount];
            [valueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *oneDict = (NSDictionary *)obj;
                id newClass = [subClass toItem:oneDict];
                [newMutList addObject:newClass];
            }];
            value = newMutList;
        }
        
        if (value != nil) {
            [class setValue:value forKey:oneIvarStr];
        }
    }
    
    return class;
}

@end
