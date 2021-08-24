//
//  ViewController.m
//  oc-kvo-impl
//
//  Created by ZJQ on 2021/8/22.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface JQObject : NSObject

@property (nonatomic, assign) int foo;

@end

@implementation JQObject

@end


@interface ViewController ()

@end

NSString *getMethods(Class cls) {
    unsigned int count;
    Method *methodList = class_copyMethodList(cls, &count);
    NSMutableString *methodNames = @"".mutableCopy;
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        [methodNames appendFormat:@"%@, ", NSStringFromSelector(method_getName(method))];
    }
    free(methodList);
    return methodNames;
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JQObject *obj1 = [[JQObject alloc] init];
    JQObject *obj2 = [[JQObject alloc] init];
    obj1.foo = 10;
    
    // 未添加 KVO 监听前
    Class obj1Isa = object_getClass(obj1);
    Class obj2Isa = object_getClass(obj2);
    NSString *obj1Methods = getMethods(obj1Isa);
    NSString *obj2Methods = getMethods(obj2Isa);
    Class obj1SuperClass = class_getSuperclass(obj1Isa);
    Class obj2SuperClass = class_getSuperclass(obj2Isa);
    IMP obj1IMP = [obj1 methodForSelector:@selector(setFoo:)];
    IMP obj2IMP = [obj2 methodForSelector:@selector(setFoo:)];
    NSLog(@"\n\n未添加 KVO 监听前:\n"
          "obj1 isa: %@\n"
          "obj2 isa: %@\n"
          "obj1 的实例方法：%@\n"
          "obj2 的实例方法：%@\n"
          "obj1 superclass: %@\n"
          "obj2 superclass: %@\n"
          "obj1 'setFoo:' 方法地址: %p\n"
          "obj2 'setFoo:' 方法地址: %p\n"
          , obj1Isa, obj2Isa, obj1Methods, obj2Methods, obj1SuperClass, obj2SuperClass, obj1IMP, obj2IMP);
    
    // 添加 KVO 监听
    [obj2 addObserver:self forKeyPath:@"foo" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    // 添加 KVO 监听后
    obj1Isa = object_getClass(obj1);
    obj2Isa = object_getClass(obj2);
    obj1Methods = getMethods(obj1Isa);
    obj2Methods = getMethods(obj2Isa);
    obj1IMP = [obj1 methodForSelector:@selector(setFoo:)];
    obj2IMP = [obj2 methodForSelector:@selector(setFoo:)];
    obj1SuperClass = class_getSuperclass(obj1Isa);
    obj2SuperClass = class_getSuperclass(obj2Isa);
    NSLog(@"\n\n添加 KVO 监听之后:\n"
          "obj1 isa: %@\n"
          "obj2 isa: %@\n"
          "obj1 的实例方法：%@\n"
          "obj2 的实例方法：%@\n"
          "obj1 superclass: %@\n"
          "obj2 superclass: %@\n"
          "obj1 'setFoo:' 方法地址: %p\n"
          "obj2 'setFoo:' 方法地址: %p\n"
          , obj1Isa, obj2Isa, obj1Methods, obj2Methods, obj1SuperClass, obj2SuperClass, obj1IMP, obj2IMP);

    // 断点 LLDB 打印 obj2IMP:
    // p obj2IMP;
    // (IMP) $0 = 0x00007fff207bf79f (Foundation`_NSSetIntValueAndNotify)
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@: %@", keyPath, change);
}


@end
