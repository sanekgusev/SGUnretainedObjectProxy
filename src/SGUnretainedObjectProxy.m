//
//  SGUnretainedObjectProxy.m
//  SGUtils
//
//  Created by Alexander Gusev on 4/21/13.
//  Copyright (c) 2013 sanekgusev. All rights reserved.
//

#import "SGUnretainedObjectProxy.h"

@interface SGUnretainedObjectProxy () {
    id __weak _originalObject;
}

@end

@implementation SGUnretainedObjectProxy

@synthesize originalObject = _originalObject;

#pragma mark - init/dealloc

- (id)init {
    [NSException raise:NSInternalInconsistencyException
                format:@"You should use -initWithNonRetainedObject: instead"];
    return nil;
}

- (id)initWithNonRetainedObject:(id)object {
    NSCParameterAssert(object);
    if (!object) {
        return nil;
    }
    _originalObject = object;
    return self;
}

#pragma mark - public

+ (instancetype)proxyWithNonRetainedObject:(id)object {
    return [[self alloc] initWithNonRetainedObject:object];
}

#pragma mark - NSProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    id strongOriginalObject = _originalObject;
    if (_cmd != aSelector && [strongOriginalObject respondsToSelector:_cmd]) {
        return [strongOriginalObject methodSignatureForSelector:aSelector];
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // TODO: check if invocation can simply be invoked with nil target instead
    id strongOriginalObject = _originalObject;
    if (strongOriginalObject) {
        [invocation invokeWithTarget:strongOriginalObject];
    }
    else {
        NSUInteger methodReturnLength = [[invocation methodSignature] methodReturnLength];
        if (methodReturnLength > 0) {
            NSMutableData *returnData = [NSMutableData dataWithLength:methodReturnLength];
            [invocation setReturnValue:[returnData mutableBytes]];
        }
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    id strongOriginalObject = _originalObject;
    if ([strongOriginalObject respondsToSelector:_cmd]) {
        id copiedObject = [strongOriginalObject copy];
        if (copiedObject == strongOriginalObject) {
            return self;
        }
        return [[self class] proxyWithNonRetainedObject:copiedObject];
    }
    [NSException raise:NSInternalInconsistencyException
                format:@"Object does not support copying"];
    return nil;
}

#pragma mark - NSMutableCopying 

- (id)mutableCopyWithZone:(NSZone *)zone {
    id strongOriginalObject = _originalObject;
    if ([strongOriginalObject respondsToSelector:_cmd]) {
        return [[self class] proxyWithNonRetainedObject:[strongOriginalObject mutableCopy]];
    }
    [NSException raise:NSInternalInconsistencyException
                format:@"Object does not support mutable copying"];
    return nil;
}

#pragma mark - NSCoding 

- (id)initWithCoder:(NSCoder *)aDecoder {
    [NSException raise:NSInternalInconsistencyException
                format:@"Cannot instantiate proxy from a decoder"];
    return nil;
}

@end
