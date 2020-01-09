
#import "RNAlibc.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <React/RCTConvert.h>

static NSInteger const PAGETYPE_DETAIL = 0;
static NSInteger const PAGETYPE_SHOP = 1;
static NSInteger const PAGETYPE_ADDCART = 2;
static NSInteger const PAGETYPE_MYORDERS = 3;
static NSInteger const PAGETYPE_MYCARTS = 4;


@interface RNAlibc() <AlibcBridgeDelegate>

@end

@implementation RNAlibc

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE(RNAliBC)

- (NSDictionary *)constantsToExport
{
  return @{
      @"TYPE_DETAIL": [NSNumber numberWithInt:PAGETYPE_DETAIL],
      @"TYPE_SHOP": [NSNumber numberWithInt:PAGETYPE_SHOP],
      @"TYPE_ADDCART": [NSNumber numberWithInt:PAGETYPE_ADDCART],
      @"TYPE_MYORDERS": [NSNumber numberWithInt:PAGETYPE_MYORDERS],
      @"TYPE_MYCARTS": [NSNumber numberWithInt:PAGETYPE_MYCARTS],
  };
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"TBLoginEvent"];
}

RCT_EXPORT_METHOD(setDebug: (BOOL)isDebug){
    [[RNAlibcBridge sharedInstance] setDebug:isDebug];
}

RCT_EXPORT_METHOD(unregisterTbBrodcasts){
    [[RNAlibcBridge sharedInstance] unregisterTbBrodcasts];
}

RCT_EXPORT_METHOD(asyncInit: (NSDictionary *)map withResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    
    if ([RCTConvert BOOL:map[@"addLoginState"]]) {
        [RNAlibcBridge sharedInstance].delegate = self;
    }
    
    [[RNAlibcBridge sharedInstance] asyncInit:map withResolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(setIsAuthVip){
    [[RNAlibcBridge sharedInstance] setIsAuthVip];
}

RCT_EXPORT_METHOD(setSyncForTaoke: (BOOL) isSyncForTaoke withResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    [[RNAlibcBridge sharedInstance] setSyncForTaoke:isSyncForTaoke withResolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(setUseAlipayNative: (BOOL) isShould){
    [[RNAlibcBridge sharedInstance] setUseAlipayNative:isShould];
}

RCT_EXPORT_METHOD(setChannel: (NSDictionary *)map){
    [[RNAlibcBridge sharedInstance] setChannel:map];
}

RCT_EXPORT_METHOD(setIsvCode: (NSString *)code withResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [[RNAlibcBridge sharedInstance] setIsvCode:code withResolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(setIsvVersion: (NSString *)version){
    [[RNAlibcBridge sharedInstance] setIsvVersion:version];
}

RCT_EXPORT_METHOD(setIsvAppName: (NSString *)name){
    [[RNAlibcBridge sharedInstance] setIsvAppName:name];
}

RCT_EXPORT_METHOD(setTaokeParams: (NSDictionary *)map){
    [[RNAlibcBridge sharedInstance] setTaokeParams:map];
}

RCT_EXPORT_METHOD(showLogin: (NSDictionary *)param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [[RNAlibcBridge sharedInstance] showLogin:param withResolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(logout: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [[RNAlibcBridge sharedInstance] logout:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(getUserInfo:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [[RNAlibcBridge sharedInstance] getUserInfo:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(openByUrl: (NSDictionary *)param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [[RNAlibcBridge sharedInstance] openByUrl:param withResolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(openByBizCode: (NSDictionary *)param type:(NSInteger)type withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [[RNAlibcBridge sharedInstance] openByBizCode:param type:type withResolver:resolve rejecter:reject];
}

/**
 * 商品详情页
 *  支持itemId和openItemId的商品，必填，不允许为null；
 *               eg.37196464781L；AAHd5d-HAAeGwJedwSnHktBI；
 */

RCT_EXPORT_METHOD(showDetailPage: (NSDictionary *) param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [[RNAlibcBridge sharedInstance] openByBizCode:param type:PAGETYPE_DETAIL withResolver:resolve rejecter: reject];
}

/**
 * 加入购物车页面
 * itemId 支持itemId和openItemId的商品，必填，不允许为null；
 *               eg.37196464781L；AAHd5d-HAAeGwJedwSnHktBI；
 */

RCT_EXPORT_METHOD(showAddCartPage: (NSDictionary *) param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [[RNAlibcBridge sharedInstance] openByBizCode:param type:PAGETYPE_ADDCART withResolver:resolve rejecter: reject];
;
}

/**
 * 我的订单页面
 *
 *  status   默认跳转页面；填写：0：全部；1：待付款；2：待发货；3：待收货；4：待评价
 *  allOrder false 进行订单分域（只展示通过当前app下单的订单），true 显示所有订单
 */
RCT_EXPORT_METHOD(showMyOrders: (NSDictionary *) param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [[RNAlibcBridge sharedInstance] openByBizCode:param type:PAGETYPE_MYORDERS withResolver:resolve rejecter: reject];
}


RCT_EXPORT_METHOD(showMyCarts: (NSDictionary *) param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [[RNAlibcBridge sharedInstance] openByBizCode:param type:PAGETYPE_MYCARTS withResolver:resolve rejecter: reject];
}
/**
 * 店铺页面
 *  shopId 店铺id，支持明文id
 */

RCT_EXPORT_METHOD(showShopPage: (NSDictionary *) param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [[RNAlibcBridge sharedInstance] openByBizCode:param type:PAGETYPE_SHOP withResolver:resolve rejecter: reject];
}


//RCT_EXPORT_METHOD(showPageByUrl: (NSDictionary *) param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
//    [self openUrlByAli:param withResolver:resolve];
//}
#pragma mark - AlibcBridgeDelegate
- (void)sendAliEventWithName:(NSString *)eventName body:(id)body{
    if([eventName isEqualToString:@"TBLoginEvent"]){
        [self sendEventWithName:eventName body:body];
    }
}

@end
  
