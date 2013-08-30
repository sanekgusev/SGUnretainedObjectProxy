//
//  SGUnretainedObjectProxy.h
//  SGUtils
//
//  Created by Alexander Gusev on 4/21/13.
//  Copyright (c) 2013 sanekgusev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGUnretainedObjectProxy : NSProxy <NSCopying,
    NSMutableCopying, NSCoding>

@property (nonatomic, readonly) id originalObject;

- (id)initWithNonRetainedObject:(id)object;
+ (instancetype)proxyWithNonRetainedObject:(id)object;

@end
