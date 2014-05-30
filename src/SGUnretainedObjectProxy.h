//
//  SGUnretainedObjectProxy.h
//  SGUtils
//
//  Created by Alexander Gusev on 4/21/13.
//  Copyright (c) 2013 sanekgusev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGUnretainedObjectProxy : NSProxy <NSCopying, NSMutableCopying>

- (id)initWithNonRetainedObject:(id)object;

@end
