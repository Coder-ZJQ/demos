//
//  main.m
//  oc-isa-to
//
//  Created by ZJQ on 2021/8/24.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/*
 objc4 源码中 isa.h L57-L113 宏定义（省略部分）
 https://github.com/Coder-ZJQ/objc4-818.2/blob/main/runtime/isa.h#L57-L113
 */
# if __arm64__
// ARM64 simulators have a larger address space, so use the ARM64e
// scheme even when simulators build for ARM64-not-e.
#   if __has_feature(ptrauth_calls) || TARGET_OS_SIMULATOR
#     define ISA_MASK        0x007ffffffffffff8ULL
#   else
#     define ISA_MASK        0x0000000ffffffff8ULL
#   endif
# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
# else
#   error unknown architecture for packed isa
# endif

@interface JQObject : NSObject

@end

@implementation JQObject

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // 创建实例对象
        JQObject *obj = [[JQObject alloc] init];
        // 获取类对象
        Class class = object_getClass(obj);
        // 获取元类对象
        Class metaClass = objc_getMetaClass("JQObject");
        // 获取基类的元类对象
        Class rootMetaClass = objc_getMetaClass("NSObject");

//        'obj->isa' 方法已过期，使用 'object_getClass(obj)' 替代获取 isa 指针
//        Direct access to Objective-C's isa is deprecated in favor of object_getClass()
//        Replace 'obj->isa' with 'object_getClass(obj)'
//        long isa = (long)obj->isa;
        
        // 将指针地址转换为长整型计算
        long objIsaAddress = (long)object_getClass(obj);
        long classAddress = (long)class;
        long classIsaAddress = (long)object_getClass(class);
        long metaClassAddress = (long)metaClass;
        long metaClassIsaAddress = (long)object_getClass(metaClass);
        long rootClassAddress = (long)rootMetaClass;
        
        // OC 运行时会对 isa 指针进行 ISA_MASK 与操作
        if ((objIsaAddress & ISA_MASK) == classAddress) {
            NSLog(@"实例对象的 isa 指针指向类对象");
        }
        if ((classIsaAddress & ISA_MASK) == metaClassAddress) {
            NSLog(@"类对象的 isa 指针指向元类对象");
        }
        if ((metaClassIsaAddress & ISA_MASK) == rootClassAddress) {
            NSLog(@"元类对象的 isa 指针指向基类的元类对象");
        }
    }
    return 0;
}
