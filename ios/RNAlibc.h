
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <React/RCTEventEmitter.h>
#import "RNAlibcBridge.h"

@interface RNAlibc : RCTEventEmitter <RCTBridgeModule>

@end
  
