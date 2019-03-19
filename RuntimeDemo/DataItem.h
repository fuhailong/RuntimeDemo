//
//  DataItem.h
//  RuntimeDemo
//
//  Created by 付海龙 on 2019/3/19.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSArray *list;
+ (NSDictionary *)arrayPropertyGenericClass;
+ (DataItem *)toItem:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
