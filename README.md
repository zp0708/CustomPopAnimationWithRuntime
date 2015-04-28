# CustomPopAnimationWithRuntime
自定义导航控制器POP动画切换控制器(支持任意位置)
利用runtime查看了UIGestureRecognizer的私有属性_targets,它的类型为NSMutableArray
如下代码:

    Ivar *var = class_copyIvarList([UIGestureRecognizer class], &count);
    unsigned int count = 0;
    for (int i = 0; i < count; i ++) {
        Ivar _var = *(var + i);
        NSLog(@"%s",ivar_getTypeEncoding(_var));
        NSLog(@"%s",ivar_getName(_var));
    }
    
控制台打印的结果(部分):

```
2015-04-28 23:12:08.527 CustomPopAnimationWithRuntime[3029:130239] @"NSMutableArray"
2015-04-28 23:12:08.527 CustomPopAnimationWithRuntime[3029:130239] _targets
2015-04-28 23:12:08.527 CustomPopAnimationWithRuntime[3029:130239] @"NSMutableArray"
2015-04-28 23:12:08.527 CustomPopAnimationWithRuntime[3029:130239] _delayedTouches
2015-04-28 23:12:08.527 CustomPopAnimationWithRuntime[3029:130239] @"UIView"
2015-04-28 23:12:08.528 CustomPopAnimationWithRuntime[3029:130239] _view
```

可见它是用数组来存储每一个target－action，所以可以动态的增加手势触发对象
可以使用kvc的方法获取到target-action内的对象
通过打印得知这个对象是UIGestureRecognizerTarget类型的
可以通过新建一个UIPanGestureRecognizer,让它的触发和系统的这个手势相同。
