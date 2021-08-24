//
//  ViewController.m
//  oc-kvc-impl
//
//  Created by ZJQ on 2021/8/24.
//

#import "ViewController.h"

@interface JQObject : NSObject
{
    @public
//    int _foo;
//    int _isFoo;
//    int foo;
//    int isFoo;
}

@end

@implementation JQObject

#pragma mark - setter

//- (void)setFoo:(int)foo {
//    _foo = foo;
//    NSLog(@"%s", __func__);
//}
//- (void)_setFoo:(int)foo {
//    _foo = foo;
//    NSLog(@"%s", __func__);
//}
//- (void)setIsFoo:(int)foo {
//    _foo = foo;
//    NSLog(@"%s", __func__);
//}

#pragma mark - getter

//- (int)getFoo {
//    NSLog(@"%s", __func__);
//    return _foo;
//}
//- (int)foo {
//    NSLog(@"%s", __func__);
//    return _foo;
//}
//- (int)isFoo {
//    NSLog(@"%s", __func__);
//    return _foo;
//}
//- (int)_getFoo {
//    NSLog(@"%s", __func__);
//    return _foo;
//}
//- (int)_foo {
//    NSLog(@"%s", __func__);
//    return _foo;
//}

+ (BOOL)accessInstanceVariablesDirectly {
    // setFoo:, _setFoo:, setIsFoo: 均未实现时
    // 可修改返回值查看输出
    return YES;
}

@end

@interface ViewController ()

@property (nonatomic, strong) JQObject *obj;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.obj setValue:@20 forKeyPath:@"foo"];
//    NSLog(@"obj.foo = %d", self.obj->_foo);
//    NSLog(@"obj.foo = %d", self.obj->_isFoo);
//    NSLog(@"obj.foo = %d", self.obj->foo);
//    NSLog(@"obj.foo = %d", self.obj->isFoo);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    id value = [self.obj valueForKey:@"foo"];
    NSLog(@"%@", value);
}

#pragma mark - lazy

- (JQObject *)obj {
    if (!_obj) {
        _obj = [[JQObject alloc] init];
    }
    return  _obj;
}

@end
