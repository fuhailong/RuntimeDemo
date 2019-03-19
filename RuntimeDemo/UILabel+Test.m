//
//  UILabel+Test.m
//  RuntimeDemo
//
//  Created by 付海龙 on 2019/3/19.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "UILabel+Test.h"
#import <objc/runtime.h>
#import <objc/message.h>

//创建一个关联的key
static NSString *abcStr = @"abcStr";

@implementation UILabel (Test)

- (void)setAbc:(NSString *)abc {
    objc_setAssociatedObject(self, &abcStr, abc, OBJC_ASSOCIATION_COPY);
}

- (NSString *)abc {
    return objc_getAssociatedObject(self, &abcStr);
}

#pragma mark -

+ (void)load {
    //方法替换 ： 将abc的set方法 替换成fu_setAbc
    SEL oldSel = @selector(setAbc:);
    SEL newSel = @selector(fu_setAbc:);
    
    Method oldMethod = class_getInstanceMethod(self, oldSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    
    //将newSel添加到当前类中，如果当前类有同名的实现，则返回NO
    BOOL boolean = class_addMethod(self, oldSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (boolean) {
        class_replaceMethod(self, newSel, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
    }else {
        method_exchangeImplementations(oldMethod, newMethod);
    }
}

- (void)fu_setAbc:(NSString *)abc {
    NSLog(@"这里是替换setAbc后的方法");
}

#pragma mark -

void test (id self, SEL _cmd, NSString *str) {
    NSLog(@"动态添加方法成功");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == NSSelectorFromString(@"test:")) {
        //void用v来表示，id参数用@来表示，SEL用:来表示
        class_addMethod(self, sel, (IMP)test, "v@:@");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

@end
