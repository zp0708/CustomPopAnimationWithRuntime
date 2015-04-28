//
//  NAViewController.m
//  testtest
//
//  Created by 赵鹏 on 15/4/27.
//  Copyright (c) 2015年 赵鹏. All rights reserved.
//

#import "NAViewController.h"
#import <objc/runtime.h>

@interface NAViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //利用runtime获取私有类UIGestureRecognizer的一些私有属性,得到系统的动画操作
    unsigned int count = 0;
    Ivar *var = class_copyIvarList([UIGestureRecognizer class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar _var = *(var + i);
        NSLog(@"%s",ivar_getTypeEncoding(_var));
        NSLog(@"%s",ivar_getName(_var));
    }
    
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];

    //获取系统手势的target数组
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];

    //获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
    id gestureRecognizerTarget = [_targets firstObject];
    
    //获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    
    //通过前面的打印，我们从控制台获取出来它的方法签名。
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    
    //创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}

@end
