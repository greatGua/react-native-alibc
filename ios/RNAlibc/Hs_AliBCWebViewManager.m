//
//  Hs_AliBCWebViewManager.m
//  RNAlibc
//
//  Created by mac on 2020/1/8.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "Hs_AliBCWebViewManager.h"

#import <React/RCTUIManager.h>
#import <React/RCTDefines.h>
#import "Hs_RNAliBCWebview.h"

@interface Hs_AliBCWebViewManager () <Hs_RNAliBCWebviewDelegate>
@end

@implementation RCTConvert (UIScrollView)

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 /* __IPHONE_11_0 */
RCT_ENUM_CONVERTER(UIScrollViewContentInsetAdjustmentBehavior, (@{
                                                                  @"automatic": @(UIScrollViewContentInsetAdjustmentAutomatic),
                                                                  @"scrollableAxes": @(UIScrollViewContentInsetAdjustmentScrollableAxes),
                                                                  @"never": @(UIScrollViewContentInsetAdjustmentNever),
                                                                  @"always": @(UIScrollViewContentInsetAdjustmentAlways),
                                                                  }), UIScrollViewContentInsetAdjustmentNever, integerValue)
#endif

@end

@implementation Hs_AliBCWebViewManager
{
  NSConditionLock *_shouldStartLoadLock;
  BOOL _shouldStartLoad;
}

RCT_EXPORT_MODULE(RNAliBCWebView)

- (UIView *)view
{
  Hs_RNAliBCWebview *webView = [Hs_RNAliBCWebview new];
  webView.delegate = self;
  return webView;
}

RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)

RCT_EXPORT_VIEW_PROPERTY(onTradeSuccess, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTradeFailure, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onLoadingStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingFinish, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onHttpError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onShouldStartLoadWithRequest, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onContentProcessDidTerminate, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(injectedJavaScript, NSString)
RCT_EXPORT_VIEW_PROPERTY(injectedJavaScriptBeforeContentLoaded, NSString)
RCT_EXPORT_VIEW_PROPERTY(javaScriptEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowFileAccessFromFileURLs, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsInlineMediaPlayback, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mediaPlaybackRequiresUserAction, BOOL)
#if WEBKIT_IOS_10_APIS_AVAILABLE
RCT_EXPORT_VIEW_PROPERTY(dataDetectorTypes, WKDataDetectorTypes)
#endif
RCT_EXPORT_VIEW_PROPERTY(contentInset, UIEdgeInsets)
RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustContentInsets, BOOL)
RCT_EXPORT_VIEW_PROPERTY(hideKeyboardAccessoryView, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsBackForwardNavigationGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(incognito, BOOL)
RCT_EXPORT_VIEW_PROPERTY(pagingEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(userAgent, NSString)
RCT_EXPORT_VIEW_PROPERTY(applicationNameForUserAgent, NSString)
RCT_EXPORT_VIEW_PROPERTY(cacheEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsLinkPreview, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowingReadAccessToURL, NSString)

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 /* __IPHONE_11_0 */
RCT_EXPORT_VIEW_PROPERTY(contentInsetAdjustmentBehavior, UIScrollViewContentInsetAdjustmentBehavior)
#endif

/**
 * Expose methods to enable messaging the webview.
 */
RCT_EXPORT_VIEW_PROPERTY(messagingEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onMessage, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onScroll, RCTDirectEventBlock)

RCT_EXPORT_METHOD(postMessage:(nonnull NSNumber *)reactTag message:(NSString *)message)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, Hs_RNAliBCWebview *> *viewRegistry) {
    Hs_RNAliBCWebview *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[Hs_RNAliBCWebview class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting Hs_RNAliBCWebview, got: %@", view);
    } else {
      [view postMessage:message];
    }
  }];
}

- (NSDictionary *)constantsToExport
{
  return @{
      @"TYPE_DETAIL": @0,
      @"TYPE_SHOP": @1,
      @"TYPE_ADDCART": @2,
      @"TYPE_MYORDERS": @3,
      @"TYPE_MYCARTS": @4
  };
}

RCT_CUSTOM_VIEW_PROPERTY(aliBCParam, NSDictionary, Hs_RNAliBCWebview) {
  [view setAliBCParam:json ? [RCTConvert NSDictionary:json] : defaultView.aliBCParam];
}

RCT_CUSTOM_VIEW_PROPERTY(bounces, BOOL, Hs_RNAliBCWebview) {
  view.bounces = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(useSharedProcessPool, BOOL, Hs_RNAliBCWebview) {
  view.useSharedProcessPool = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(scrollEnabled, BOOL, Hs_RNAliBCWebview) {
  view.scrollEnabled = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(sharedCookiesEnabled, BOOL, Hs_RNAliBCWebview) {
    view.sharedCookiesEnabled = json == nil ? false : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(decelerationRate, CGFloat, Hs_RNAliBCWebview) {
  view.decelerationRate = json == nil ? UIScrollViewDecelerationRateNormal : [RCTConvert CGFloat: json];
}

RCT_CUSTOM_VIEW_PROPERTY(directionalLockEnabled, BOOL, Hs_RNAliBCWebview) {
    view.directionalLockEnabled = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(showsHorizontalScrollIndicator, BOOL, Hs_RNAliBCWebview) {
  view.showsHorizontalScrollIndicator = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(showsVerticalScrollIndicator, BOOL, Hs_RNAliBCWebview) {
  view.showsVerticalScrollIndicator = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(keyboardDisplayRequiresUserAction, BOOL, Hs_RNAliBCWebview) {
  view.keyboardDisplayRequiresUserAction = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_EXPORT_METHOD(injectJavaScript:(nonnull NSNumber *)reactTag script:(NSString *)script)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, Hs_RNAliBCWebview *> *viewRegistry) {
    Hs_RNAliBCWebview *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[Hs_RNAliBCWebview class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting Hs_RNAliBCWebview, got: %@", view);
    } else {
      [view injectJavaScript:script];
    }
  }];
}

RCT_EXPORT_METHOD(goBack:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, Hs_RNAliBCWebview *> *viewRegistry) {
    Hs_RNAliBCWebview *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[Hs_RNAliBCWebview class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting Hs_RNAliBCWebview, got: %@", view);
    } else {
      [view goBack];
    }
  }];
}

RCT_EXPORT_METHOD(goForward:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, Hs_RNAliBCWebview *> *viewRegistry) {
    Hs_RNAliBCWebview *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[Hs_RNAliBCWebview class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting Hs_RNAliBCWebview, got: %@", view);
    } else {
      [view goForward];
    }
  }];
}

RCT_EXPORT_METHOD(reload:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, Hs_RNAliBCWebview *> *viewRegistry) {
    Hs_RNAliBCWebview *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[Hs_RNAliBCWebview class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting Hs_RNAliBCWebview, got: %@", view);
    } else {
      [view reload];
    }
  }];
}

RCT_EXPORT_METHOD(stopLoading:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, Hs_RNAliBCWebview *> *viewRegistry) {
    Hs_RNAliBCWebview *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[Hs_RNAliBCWebview class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting Hs_RNAliBCWebview, got: %@", view);
    } else {
      [view stopLoading];
    }
  }];
}

#pragma mark - Exported synchronous methods

- (BOOL)webView:(Hs_RNAliBCWebview *)webView shouldStartLoadForRequest:(NSMutableDictionary<NSString *, id> *)request withCallback:(RCTDirectEventBlock)callback
{
  _shouldStartLoadLock = [[NSConditionLock alloc] initWithCondition:arc4random()];
  _shouldStartLoad = YES;
  request[@"lockIdentifier"] = @(_shouldStartLoadLock.condition);
  callback(request);

  // Block the main thread for a maximum of 250ms until the JS thread returns
  if ([_shouldStartLoadLock lockWhenCondition:0 beforeDate:[NSDate dateWithTimeIntervalSinceNow:.25]]) {
    BOOL returnValue = _shouldStartLoad;
    [_shouldStartLoadLock unlock];
    _shouldStartLoadLock = nil;
    return returnValue;
  } else {
    RCTLogWarn(@"Did not receive response to shouldStartLoad in time, defaulting to YES");
    return YES;
  }
}

RCT_EXPORT_METHOD(startLoadWithResult:(BOOL)result lockIdentifier:(NSInteger)lockIdentifier)
{
  if ([_shouldStartLoadLock tryLockWhenCondition:lockIdentifier]) {
    _shouldStartLoad = result;
    [_shouldStartLoadLock unlockWithCondition:0];
  } else {
    RCTLogWarn(@"startLoadWithResult invoked with invalid lockIdentifier: "
               "got %lld, expected %lld", (long long)lockIdentifier, (long long)_shouldStartLoadLock.condition);
  }
}

@end

