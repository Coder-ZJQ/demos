//
//  main.m
//  oc-nsobject-size
//
//  Created by ZJQ on 2021/8/24.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSObject *obj = [[NSObject alloc] init];

        // 获得 NSObject 类的实例对象的成员变量所占用的大小
        size_t instanceSize = class_getInstanceSize([NSObject class]);
        // 获得 obj 指针所指向内存大小
        size_t mallocSize = malloc_size((__bridge const void *)(obj));

        NSLog(@"instance size:%zu", instanceSize);  // 8
        NSLog(@"malloc size:%zu", mallocSize);      // 16
    }
    return 0;
}
