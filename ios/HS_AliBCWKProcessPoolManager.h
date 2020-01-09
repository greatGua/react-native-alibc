//
//  HS_AliBCWKProcessPoolManager.h
//  RNAlibc
//
//  Created by mac on 2020/1/8.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HS_AliBCWKProcessPoolManager : NSObject

+ (instancetype) sharedManager;
- (WKProcessPool *)sharedProcessPool;

@end

NS_ASSUME_NONNULL_END
