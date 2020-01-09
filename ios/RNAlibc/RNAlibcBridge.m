
#import "RNAlibcBridge.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <React/RCTConvert.h>
#import "UIKit/UIKit.h"

static NSInteger const PAGETYPE_DETAIL = 0;
static NSInteger const PAGETYPE_SHOP = 1;
static NSInteger const PAGETYPE_ADDCART = 2;
static NSInteger const PAGETYPE_MYORDERS = 3;
static NSInteger const PAGETYPE_MYCARTS = 4;


@implementation RNAlibcBridge{
    UIViewController *mainViewController;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE(RNAliBCBridge)


-(id) init{
    if(self == [super init]){
        mainViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    
    return self;
}

+ (instancetype) sharedInstance
{
    static RNAlibcBridge *instance = nil;
    if (!instance) {
        instance = [[RNAlibcBridge alloc] init];
    }
    return instance;
}




RCT_EXPORT_METHOD(setDebug: (BOOL )isDebug)
{
    
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:isDebug];
}

RCT_EXPORT_METHOD(unregisterTbBrodcasts)
{
    [[ALBBSDK sharedInstance] setLoginResultHandler:nil];
}

RCT_EXPORT_METHOD(asyncInit: (NSDictionary *)map withResolver:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)
{
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:[RCTConvert BOOL:map[@"debug"]]];

    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        if ([RCTConvert BOOL:map[@"addLoginState"]]) {
            
            [[ALBBSDK sharedInstance] setLoginResultHandler:^(ALBBSession *session) {
                [self.delegate sendAliEventWithName:@"TBLoginEvent" body:@{@"openId":session.getUser.openId,@"openSid":session.getUser.openSid,@"nick":session.getUser.nick,@"avatarUrl":session.getUser.avatarUrl,@"topAccessToken":session.getUser.topAccessToken,@"topAuthCode":session.getUser.topAuthCode}];

            }];
        }
        
        resolve(@{
            @"status": @YES,
            @"message": @"淘宝初始化成功"
        });
    } failure:^(NSError *error) {
        resolve(@{
            @"status": @NO,
            @"message": @"淘宝初始化失败"
        });
    }];
}

RCT_EXPORT_METHOD(setIsAuthVip)
{
    [[AlibcTradeSDK sharedInstance] enableAuthVipMode];
}

RCT_EXPORT_METHOD(setSyncForTaoke: (BOOL) isSyncForTaoke withResolver:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)
{
    [[AlibcTradeSDK sharedInstance] setIsSyncForTaoke:isSyncForTaoke];
    resolve(@{
        @"status": @YES
    });
}

RCT_EXPORT_METHOD(setUseAlipayNative: (BOOL) isShould)
{
    [[AlibcTradeSDK sharedInstance] setShouldUseAlizfNative:isShould];
  
}

RCT_EXPORT_METHOD(setChannel: (NSDictionary *)map)
{
    [[AlibcTradeSDK sharedInstance] setChannel:[RCTConvert NSString:map[@"typeName"]] name:[RCTConvert NSString:map[@"channelName"]]];
}

RCT_EXPORT_METHOD(setIsvCode: (NSString *)code withResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[AlibcTradeSDK sharedInstance] setISVCode:code];
    resolve(@{
        @"status": @YES
    });
}

RCT_EXPORT_METHOD(setIsvVersion: (NSString *)version)
{
    [[AlibcTradeSDK sharedInstance] setISVCode:version];
}

RCT_EXPORT_METHOD(setIsvAppName: (NSString *)name)
{
    [[AlibcTradeSDK sharedInstance] setIsvAppName:name];
}

RCT_EXPORT_METHOD(setTaokeParams: (NSDictionary *)map)
{
    [[AlibcTradeSDK sharedInstance] setTaokeParams:[self getTaokeParam:map]];
    
}

RCT_EXPORT_METHOD(showLogin: (NSDictionary *)param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{

    [[ALBBSDK sharedInstance] setAuthOption: [RCTConvert BOOL:param[@"H5Only"]] ? H5Only : NormalAuth];
    [[ALBBSDK sharedInstance] auth:mainViewController successCallback:^(ALBBSession *session) {

        NSDictionary *ret = @{@"status":@YES,
                              @"nick":session.getUser.nick,
                              @"avatarUrl":session.getUser.avatarUrl,
                              @"openSid":session.getUser.openSid,
                              @"openId":session.getUser.openId,
                              @"isLogin":@(session.isLogin),
                              @"topAccessToken":session.getUser.topAccessToken,
                              @"topAuthCode":session.getUser.topAuthCode
                              };

        resolve(ret);
    } failureCallback:^(ALBBSession *session, NSError *error) {
        resolve(@{@"status":@NO,@"code":[NSNumber numberWithInteger:error.code],@"message":error.description});
        return;
    }];
}

RCT_EXPORT_METHOD(logout: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){

    [[ALBBSDK sharedInstance] logoutWithCallback:^{
        resolve(@{@"status":@YES});
    }];
}

RCT_EXPORT_METHOD(getUserInfo:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    ALBBSession *session = [ALBBSession sharedInstance];
    if(!session.isLogin||![session getUser]){
        [self statusBak:NO msg:nil withResolver:resolve];
    }else{
        [self sessionBak:resolve Session:session];
    }
    
}

RCT_EXPORT_METHOD(openByUrl: (NSDictionary *)param withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
    [self openUrlByAli:param withResolver:resolve];
}


RCT_EXPORT_METHOD(openByBizCode: (NSDictionary *)param type:(NSInteger)type withResolver: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [self openPageByAli:param type:type withResolver:resolve];
}


RCT_EXPORT_METHOD(openByUrl_inWebView:(UIWebView *)bcWebView url:(NSString *) url param:(NSDictionary *) param withResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    if(![self notBlankString:url]){
        return;
    }
    
    //设置页面打开方式
    AlibcTradeShowParams *showParams = [self getShowParam:param];
    showParams.openType = AlibcOpenTypeAuto;
    //设置淘客参数
    AlibcTradeTaokeParams *taokeParams = [self getTaokeParam:param];
    //设置链路跟踪参数
    NSDictionary *exParams = [self getTrackParam:param];

    NSString *kitName = [RCTConvert NSString:param[@"identity"]];
    kitName = kitName ? kitName : @"trade";
    
    NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService openByUrl:url identity:kitName webView:bcWebView parentController:mainViewController showParams:showParams taoKeParams:taokeParams trackParam:exParams tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {

        if(result.result == AlibcTradeResultTypeAddCard){
            resolve(@{@"status":@YES,@"message":@"加购成功"});
        }else{
            resolve(@{@"status":@YES,@"ordersId":result.payResult.paySuccessOrders});
        }
        
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        resolve(@{@"status":@NO, @"code":@(error.code),@"message":error.description});
    }];
    
    //needPush = yes;的时候
    if (res == 1) {
        //        [self.viewController.navigationController pushViewController:UIView animated:YES];
    }
    
}

RCT_EXPORT_METHOD(openByBizCode_inWebView:(UIWebView *)bcWebView type:(NSInteger)type param:(NSDictionary *) param withResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    id<AlibcTradePage> page = nil;
    NSString *pageCode = [RCTConvert NSString:param[@"code"]];//nil
    if (type == PAGETYPE_DETAIL) {//detail
        NSString *itemId = [RCTConvert NSString:param[@"itemId"]];
        page = [AlibcTradePageFactory itemDetailPage:itemId];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"detail";
    }else if (type == PAGETYPE_ADDCART){//加购
        page = [AlibcTradePageFactory addCartPage:[RCTConvert NSString:param[@"itemId"]]];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"addCart";
    }else if (type == PAGETYPE_MYCARTS){//我的购物车
        page = [AlibcTradePageFactory myCartsPage];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"cart";
    }else if (type == PAGETYPE_MYORDERS){//我的订单页面
        NSInteger status = [RCTConvert NSInteger:param[@"orderStatus"]];//0
        BOOL allOrder = [RCTConvert BOOL:param[@"allOrder"]];
        page = [AlibcTradePageFactory myOrdersPage:status isAllOrder:allOrder];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"order";
    }else if (type == PAGETYPE_SHOP){//店铺
        page = [AlibcTradePageFactory shopPage:[RCTConvert NSString:param[@"shopId"]]];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"shop";
    }
    //设置页面打开方式
    AlibcTradeShowParams *showParams = [self getShowParam:param];
    //设置淘客参数
    AlibcTradeTaokeParams *taokeParams = [self getTaokeParam:param];
    //设置链路跟踪参数
    NSDictionary *exParams = [self getTrackParam:param];

    
    NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService openByBizCode:pageCode page:page webView:bcWebView parentController:mainViewController showParams:showParams taoKeParams:taokeParams trackParam:exParams tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
         
         if(result.result == AlibcTradeResultTypeAddCard){
             resolve(@{@"status":@YES,@"message":@"加购成功"});
         }else{
             resolve(@{@"status":@YES,@"ordersId":result.payResult.paySuccessOrders});
         }
         
     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
         resolve(@{@"status":@NO,@"code":@(error.code),@"message":error.description});
     }];
     
     //needPush = yes;的时候
     if (res == 1) {
    
     }
    
}


/*本地方法，方便使用*/
-(void)openPageByAli:(NSDictionary *) param type:(NSInteger)type withResolver: (RCTPromiseResolveBlock)resolve{

    id<AlibcTradePage> page = nil;
    NSString *pageCode = [RCTConvert NSString:param[@"code"]];//nil
    if (type == PAGETYPE_DETAIL) {//detail
        NSString *itemId = [RCTConvert NSString:param[@"itemId"]];
        page = [AlibcTradePageFactory itemDetailPage:itemId];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"detail";
    }else if (type == PAGETYPE_ADDCART){//加购
        page = [AlibcTradePageFactory addCartPage:[RCTConvert NSString:param[@"itemId"]]];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"addCart";
    }else if (type == PAGETYPE_MYCARTS){//我的购物车
        page = [AlibcTradePageFactory myCartsPage];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"cart";
    }else if (type == PAGETYPE_MYORDERS){//我的订单页面
        NSInteger status = [RCTConvert NSInteger:param[@"orderStatus"]];//0
        BOOL allOrder = [RCTConvert BOOL:param[@"allOrder"]];
        page = [AlibcTradePageFactory myOrdersPage:status isAllOrder:allOrder];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"order";
    }else if (type == PAGETYPE_SHOP){//店铺
        page = [AlibcTradePageFactory shopPage:[RCTConvert NSString:param[@"shopId"]]];
        pageCode = [self notBlankString:pageCode] ? pageCode : @"shop";
    }
    //设置页面打开方式
    AlibcTradeShowParams *showParams = [self getShowParam:param];
    //设置淘客参数
    AlibcTradeTaokeParams *taokeParams = [self getTaokeParam:param];
    //设置链路跟踪参数
    NSDictionary *exParams = [self getTrackParam:param];
    
    NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService openByBizCode:pageCode page:page webView:nil parentController:mainViewController showParams:showParams taoKeParams:taokeParams trackParam:exParams tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        
        if(result.result == AlibcTradeResultTypeAddCard){
            resolve(@{@"status":@YES,@"message":@"加购成功"});
        }else{
            resolve(@{@"status":@YES,@"ordersId":result.payResult.paySuccessOrders});
        }
        
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        resolve(@{@"status":@NO,@"code":@(error.code),@"message":error.description});
    }];
    
    //needPush = yes;的时候
    if (res == 1) {
   
    }

}

-(void)openUrlByAli:(NSDictionary *) param withResolver: (RCTPromiseResolveBlock)resolve{
    
    NSString *url = [RCTConvert NSString:param[@"url"]];
    if(![self notBlankString:url]){
        return;
    }
    //设置页面打开方式
    AlibcTradeShowParams *showParams = [self getShowParam:param];
    //设置淘客参数
    AlibcTradeTaokeParams *taokeParams = [self getTaokeParam:param];
    //设置链路跟踪参数
    NSDictionary *exParams = [self getTrackParam:param];
    NSString *kitName = [RCTConvert NSString:param[@"identity"]];
    kitName = kitName ? kitName : @"trade";
    
    NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService openByUrl:url identity:kitName webView:nil parentController:mainViewController showParams:showParams taoKeParams:taokeParams trackParam:exParams tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        
        if(result.result == AlibcTradeResultTypeAddCard){
            resolve(@{@"status":@YES,@"message":@"加购成功"});
        }else{
            resolve(@{@"status":@YES,@"ordersId":result.payResult.paySuccessOrders});
        }
        
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        resolve(@{@"status":@NO, @"code":@(error.code),@"message":error.description});
    }];
    
    //needPush = yes;的时候
    if (res == 1) {
        //        [self.viewController.navigationController pushViewController:UIView animated:YES];
    }
}


-(AlibcTradeTaokeParams *)getTaokeParam: (NSDictionary *)map{

    NSString *pid = [RCTConvert NSString:map[@"pid"]];
    NSString *unionId = [RCTConvert NSString:map[@"unionId"]];
    NSString *subPid = [RCTConvert NSString:map[@"subPid"]];
    
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = pid;
    taokeParams.unionId = unionId;
    taokeParams.subPid = subPid;
    
    NSString *adzoneId = [RCTConvert NSString:map[@"adzoneId"]];
    NSDictionary *exParams = [RCTConvert NSDictionary:map[@"extraParams"]];
    //    NSString *taokeAppkey = [param stringValueForKey:@"taokeAppkey" defaultValue:nil];

    if (adzoneId) {
        taokeParams.adzoneId = adzoneId;
    }
    if (exParams != nil) {
        taokeParams.extParams = exParams;
    }
    return taokeParams;
}

- (AlibcTradeShowParams *) getShowParam:(NSDictionary *)param {
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    
    NSString *openType = [RCTConvert NSString:param[@"openType"]];//"auto"
    NSString *linkKey = [RCTConvert NSString:param[@"linkKey"]];//taobao
    NSString *degradeUrl = [RCTConvert NSString:param[@"degradeUrl"]];//nil
    
    BOOL isNeedPush = [RCTConvert BOOL:param[@"isNeedPush"]];//NO
    
    if ([openType isEqualToString:@"auto"]) {
        showParams.openType = AlibcOpenTypeAuto;
    }else if([openType isEqualToString:@"native"]){
        showParams.openType = AlibcOpenTypeNative;
    }
    showParams.isNeedPush = isNeedPush;
    showParams.linkKey = linkKey;
    if ([self notBlankString:degradeUrl]) {
        showParams.degradeUrl = degradeUrl;
    }
    
    NSString *failModeType = [RCTConvert NSString:param[@"degradeUrl"]];// nil
    if (failModeType) {
        showParams.isNeedCustomNativeFailMode = YES;
        if ([failModeType isEqualToString:@"none"]) {
            showParams.nativeFailMode = AlibcNativeFailModeNone;
        }else if([failModeType isEqualToString:@"jumpDownload"]){
            showParams.nativeFailMode = AlibcNativeFailModeJumpDownloadPage;
        }else{
            showParams.nativeFailMode = AlibcNativeFailModeJumpH5;
        }
    }
    NSString *backUrl = [RCTConvert NSString:param[@"backUrl"]];//nil
    showParams.backUrl = backUrl ? backUrl : showParams.backUrl;
    
    return showParams;
}

- (NSDictionary *) getTrackParam:(NSDictionary *)param {
    //设置链路跟踪参数
    NSDictionary *exParams = [RCTConvert NSDictionary:param[@"trackParams"]];//nil
    NSString *appIsvCode = [RCTConvert NSString:param[@"isvCode"]];//nil
    
    if (appIsvCode) {
        [[AlibcTradeSDK sharedInstance]setISVCode:appIsvCode];
    }
    return exParams;
}

-(void)statusBak:(BOOL) isOk msg:(nullable NSString *) msg withResolver: (RCTPromiseResolveBlock)resolve{

    NSDictionary *ret = nil;
    if(![self notBlankString:msg]){
        ret = @{@"status":[NSNumber numberWithBool:isOk]};
    }else{
        ret = @{@"status":[NSNumber numberWithBool:isOk],@"message":msg};
    }
    resolve(ret);
}

-(void)sessionBak:(RCTPromiseResolveBlock)resolve Session:(ALBBSession *)session{

        NSDictionary *ret = @{@"status":@YES,
                              @"nick":session.getUser.nick,
                              @"avatarUrl":session.getUser.avatarUrl,
                              @"openSid":session.getUser.openSid,
                              @"openId":session.getUser.openId,
                              @"isLogin":@(session.isLogin),
                              @"topAccessToken":session.getUser.topAccessToken,
                              @"topAuthCode":session.getUser.topAuthCode
                              };
    resolve(ret);
}

- (BOOL) notBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return NO;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return NO;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return NO;
        
    }
    
    return YES;
    
}

@end
  
