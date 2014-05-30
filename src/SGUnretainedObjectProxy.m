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
    Class __unsafe_unretained _originalObjectClass;
}

@end

@implementation SGUnretainedObjectProxy

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
    _originalObjectClass = [object class];
    return self;
}

#pragma mark - NSProxy

- (id)forwardingTargetForSelector:(SEL)aSelector {
    id strongOriginalObject = _originalObject;
    return strongOriginalObject;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSCAssert(!_originalObject, @"_originalObject");
    return [_originalObjectClass instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSCAssert(!_originalObject, @"_originalObject");
    NSUInteger methodReturnLength = [[invocation methodSignature] methodReturnLength];
    if (methodReturnLength > 0) {
        NSMutableData *returnData = [NSMutableData dataWithLength:methodReturnLength];
        [invocation setReturnValue:[returnData mutableBytes]];
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    id strongOriginalObject = _originalObject;
    if (!strongOriginalObject) {
        return nil;
    }
    id copiedObject = [strongOriginalObject copy];
    if (copiedObject == strongOriginalObject) {
        return self;
    }
    return [[[self class] alloc] initWithNonRetainedObject:copiedObject];
}

#pragma mark - NSMutableCopying 

- (id)mutableCopyWithZone:(NSZone *)zone {
    id strongOriginalObject = _originalObject;
    if (!strongOriginalObject) {
        return nil;
    }
    return [[[self class] alloc] initWithNonRetainedObject:[strongOriginalObject mutableCopy]];
}

@end
