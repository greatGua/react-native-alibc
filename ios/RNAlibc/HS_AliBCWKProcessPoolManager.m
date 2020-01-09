//
//  HS_AliBCWKProcessPoolManager.m
//  RNAlibc
//
//  Created by mac on 2020/1/8.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HS_AliBCWKProcessPoolManager.h"

@interface HS_AliBCWKProcessPoolManager() {
    WKProcessPool *_sharedProcessPool;
}
@end

@implementation HS_AliBCWKProcessPoolManager

+ (id) sharedManager {
    static HS_AliBCWKProcessPoolManager *_sharedManager = nil;
    @synchronized(self) {
        if(_sharedManager == nil) {
            _sharedManager = [[super alloc] init];
        }
        return _sharedManager;
    }
}

- (WKProcessPool *)sharedProcessPool {
    if (!_sharedProcessPool) {
        _sharedProcessPool = [[WKProcessPool alloc] init];
    }
    return _sharedProcessPool;
}

@end
