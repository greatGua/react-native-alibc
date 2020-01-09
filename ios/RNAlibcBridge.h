//
//  RNAlibcBridge.h
//  RNAlibc
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020 Facebook. All rights reserved.
//

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <WebKit/WebKit.h>

@protocol AlibcBridgeDelegate <NSObject>

- (void)sendAliEventWithName:(NSString *_Nonnull)eventName body:(id _Nullable)body;

@end

@protocol AlibcBridgeWebViewDelegate <NSObject>

- (void)tradeSuccess:(id _Nullable)body;
- (void)tradeFailure:(id _Nullable)body;

@end

@interface RNAlibcBridge : NSObject <RCTBridgeModule>

@property (weak, nonatomic) id<AlibcBridgeDelegate> _Nullable delegate;
@property (weak, nonatomic) id<AlibcBridgeWebViewDelegate> _Nullable webViewDelegate;

+ (instancetype _Nullable )sharedInstance;
- (void)setDebug: (BOOL)isDebug;
- (void)unregisterTbBrodcasts;
- (void)asyncInit: (NSDictionary *_Nullable)map withResolver:(RCTPromiseResolveBlock _Nullable)resolve
rejecter:(RCTPromiseRejectBlock _Nullable)reject;
- (void)setIsAuthVip;
- (void)setSyncForTaoke: (BOOL) isSyncForTaoke withResolver:(RCTPromiseResolveBlock _Nullable )resolve
rejecter:(RCTPromiseRejectBlock _Nullable)reject;
- (void)setUseAlipayNative: (BOOL) isShould;
- (void)setChannel: (NSDictionary *_Nonnull)map;
- (void)setIsvCode: (NSString *_Nonnull)code withResolver:(RCTPromiseResolveBlock _Nullable)resolve rejecter:(RCTPromiseRejectBlock _Nullable)reject;
- (void)setIsvVersion: (NSString *_Nonnull)version;
- (void)setIsvAppName: (NSString *_Nonnull)name;
- (void)setTaokeParams: (NSDictionary *_Nonnull)map;
- (void)showLogin: (NSDictionary * _Nullable)param withResolver: (RCTPromiseResolveBlock _Nullable)resolve rejecter:(RCTPromiseRejectBlock _Nullable)reject;

- (void)logout: (RCTPromiseResolveBlock _Nullable )resolve rejecter:(RCTPromiseRejectBlock _Nullable )reject;
- (void)getUserInfo:(RCTPromiseResolveBlock _Nullable)resolve rejecter:(RCTPromiseRejectBlock _Nullable )reject;
- (void)openByUrl: (NSDictionary *_Nonnull)param withResolver: (RCTPromiseResolveBlock _Nullable )resolve rejecter:(RCTPromiseRejectBlock _Nullable )reject;
- (void)openByBizCode: (NSDictionary *_Nonnull)param type:(NSInteger)type withResolver: (RCTPromiseResolveBlock _Nullable)resolve rejecter:(RCTPromiseRejectBlock _Nullable )reject;

- (void)openByUrl_inWebView:(UIWebView *_Nonnull)bcWebView url:(NSString *_Nonnull) url param:(NSDictionary *_Nonnull) param withResolver:(RCTPromiseResolveBlock _Nullable)resolve rejecter:(RCTPromiseRejectBlock _Nullable)reject;

- (void)openByBizCode_inWebView:(UIWebView *_Nonnull)bcWebView type:(NSInteger)type param:(NSDictionary *_Nonnull) param withResolver:(RCTPromiseResolveBlock _Nullable )resolve rejecter:(RCTPromiseRejectBlock _Nullable )reject;
@end
