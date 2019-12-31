
package com.inshare.alibc;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.annotation.NonNull;
import android.text.TextUtils;
import android.webkit.WebChromeClient;
import android.webkit.WebViewClient;
import android.widget.ImageView;

import com.ali.auth.third.core.broadcast.LoginAction;
import com.ali.auth.third.core.model.Session;
import com.ali.auth.third.ui.context.CallbackContext;
import com.alibaba.baichuan.android.trade.AlibcTrade;
import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeCallback;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback;
import com.alibaba.baichuan.android.trade.model.AlibcShowParams;
import com.alibaba.baichuan.android.trade.model.OpenType;
import com.alibaba.baichuan.android.trade.page.AlibcAddCartPage;
import com.alibaba.baichuan.android.trade.page.AlibcBasePage;
import com.alibaba.baichuan.android.trade.page.AlibcDetailPage;
import com.alibaba.baichuan.android.trade.page.AlibcMyCartsPage;
import com.alibaba.baichuan.android.trade.page.AlibcMyOrdersPage;
import com.alibaba.baichuan.android.trade.page.AlibcShopPage;
import com.alibaba.baichuan.trade.biz.applink.adapter.AlibcFailModeType;
import com.alibaba.baichuan.trade.biz.context.AlibcTradeResult;
import com.alibaba.baichuan.trade.biz.core.taoke.AlibcTaokeParams;
import com.alibaba.baichuan.trade.biz.login.AlibcLogin;
import com.alibaba.baichuan.trade.biz.login.AlibcLoginCallback;
import com.alibaba.baichuan.trade.common.AlibcTradeCommon;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.IllegalViewOperationException;
import com.inshare.alibc.utils.Hs_IDFinder;
import com.inshare.alibc.utils.Hs_Map;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;

import static com.inshare.alibc.utils.Hs_RnUtil.sendEvent;

public class RNAlibcModule extends ReactContextBaseJavaModule {
  private final ReactApplicationContext reactApplicationContext;
  private final Context reactContext;
  public static final String MODULE_NAME = "RNAlibc";

  private static final int PAGETYPE_DETAIL = 0;
  private static final int PAGETYPE_SHOP = 1;
  private static final int PAGETYPE_ADDCART = 2;
  private static final int PAGETYPE_MYORDERS = 3;
  private static final int PAGETYPE_MYCARTS = 4;

  private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
      CallbackContext.onActivityResult(requestCode, resultCode, intent);
    }
  };

  public RNAlibcModule(@NonNull ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.reactApplicationContext = reactContext;
    reactContext.addActivityEventListener(mActivityEventListener);
  }

  static private RNAlibcModule mRNModuleAlibc = null;
  static public RNAlibcModule sharedInstance(ReactApplicationContext context) {
    if (mRNModuleAlibc == null)
      return new RNAlibcModule(context);
    else
      return mRNModuleAlibc;
  }

  @NonNull
  @Override
  public String getName() {
    return MODULE_NAME;
  }

  /**
   * 一个可选的方法getContants返回了需要导出给 JavaScript 使用的常量。
   * 它并不一定需要实现，但在定义一些可以被 JavaScript 同步访问到的预定义的值时非常有用。
   * */
  @Override
  public Map<String, Object> getConstants() {
    final Map<String, Object> constants = new HashMap<>();
    constants.put("typeDetail", PAGETYPE_DETAIL);
    constants.put("typeShop", PAGETYPE_SHOP);
    constants.put("typeAddCart", PAGETYPE_ADDCART);
    constants.put("typeMyOrders", PAGETYPE_MYORDERS);
    constants.put("typeMyCarts", PAGETYPE_MYCARTS);
    return constants;
  }

  @ReactMethod
  public void setDebug(ReadableMap map, Promise promise) {
    if(map.getBoolean("debug")) {
      AlibcTradeCommon.turnOnDebug();
    }else{
      AlibcTradeCommon.turnOffDebug();
    }
  }

  @ReactMethod
  public void asyncInit(ReadableMap map, final Promise promise) {
    final Hs_Map rnParams = new Hs_Map(map);
    if(rnParams.optBoolean("keepImg", true)) {
//        shrinkResources false//设置为false，true的话，安全图片可能会被删除
      final ImageView kyinyong = new ImageView(reactContext);
      int resId = Hs_IDFinder.getResDrawableID("yw_1222.jpg");
      kyinyong.setImageResource(resId);
    }

    if(rnParams.optBoolean("debug",true)) {
      AlibcTradeCommon.turnOnDebug();
    }else{
      AlibcTradeCommon.turnOffDebug();
    }
    AlibcTradeSDK.asyncInit(getCurrentActivity().getApplication(), new AlibcTradeInitCallback() {
      @Override
      public void onSuccess() {
        if(rnParams.optBoolean("addLoginState",true)){
          addTBLoginState();
        }
        successBack(0,"淘宝初始化成功",promise);
      }
      @Override
      public void onFailure(int code, String msg) {
        failureBack(code,"淘宝初始化失败:"+msg,promise);
      }
    });
  }

  @ReactMethod
  public void setIsAuthVip(ReadableMap map, Promise promise) {
    AlibcTradeSDK.setIsAuthVip(new Hs_Map(map).optBoolean("isVip",true));
  }

  @ReactMethod
  public void setSyncForTaoke(ReadableMap map, Promise promise){
    boolean isSuccess = AlibcTradeSDK.setSyncForTaoke(new Hs_Map(map).optBoolean("isSyncForTaoke",true));
    statusBack(isSuccess,"",promise);
  }

  @ReactMethod
  public void setUseAlipayNative(ReadableMap map){
    AlibcTradeSDK.setShouldUseAlipay(new Hs_Map(map).optBoolean("isShould",true));
  }

  @ReactMethod
  public void setChannel(ReadableMap map, Promise promise){
    Hs_Map paramDict = new Hs_Map(map);
    String typeName = paramDict.optString("typeName","0");
    String channelName = paramDict.optString("channelName",null);
    AlibcTradeSDK.setChannel(typeName,channelName);
  }

  @ReactMethod
  public void setIsvCode(ReadableMap map, Promise promise){
    String isvCode = new Hs_Map(map).optString("code");
    boolean isSuccess = AlibcTradeSDK.setISVCode(isvCode);
    statusBack(isSuccess,"",promise);
  }

  /**
   * 设置isv的版本 ，通常为三方app版本，可以不进行设置；默认1.0.0
   * 注意：初始化完成后调用才能生效
   *
   *  isvVersion
   *  返回isv version是否设置成功
   */
  //已经下线
  @ReactMethod
  public void setIsvVersion(ReadableMap map){
    String isvVersion = new Hs_Map(map).optString("version");
    AlibcTradeSDK.setISVVersion(isvVersion);
  }

  /**
   * 设置全局淘客参数，方便开发者用同一个淘客参数，不需要在show接口重复传入
   * 注意：初始化完成后调用才能生效
   *
   * taokeParams 淘客参数
   */
  @ReactMethod
  public void setTaokeParams(ReadableMap map, Promise promise){
    AlibcTaokeParams taokeParams = getTaokeParam(map);
    boolean isValidPid = taokeParams.isValidPid();
    if (isValidPid)AlibcTradeSDK.setTaokeParams(taokeParams);
    statusBack(isValidPid,null,promise);
  }

  @ReactMethod
  public void unregisterTbBrodcast(){
    try{
      if (hasRegist){
        reactContext.unregisterReceiver(tbLoginReceiver);
        hasRegist = false;
      }
    } catch (Exception e){}
  }


  @ReactMethod
  public void showLogin(final Promise promise){
    AlibcLogin.getInstance().showLogin(new AlibcLoginCallback() {
      @Override
      public void onSuccess(int i, String userId, String nick) {
        Session session = AlibcLogin.getInstance().getSession();
        sessionBack(promise,session);
      }

      @Override
      public void onFailure(int i, String s) {
        failureBack(i,s,promise);
      }

    });
  }

  //退出授权登陆
  @ReactMethod
  public void logout(final Promise promise){
    AlibcLogin.getInstance().logout(new AlibcLoginCallback() {
      @Override
      public void onSuccess(int i,String userId, String nick) {
        statusBack(true,null,promise);
      }
      @Override
      public void onFailure(int i, String s) {
        failureBack(i,s,promise);
      }
    });
  }



  //淘宝登录状态改变监听 广播
  private BroadcastReceiver tbLoginReceiver = new BroadcastReceiver(){

    @Override
    public void onReceive(Context context, Intent intent) {
      String action = intent.getAction();
      LoginAction a = LoginAction.valueOf(action);
      switch (a) {
        case NOTIFY_LOGIN_SUCCESS:
          Session session = AlibcLogin.getInstance().getSession();
          WritableMap o = Arguments.createMap();
          try {
            if (!TextUtils.isEmpty(session.openId)){
              o.putString("openId",session.openId+"");
              o.putString("openSid",session.openSid+"");
              o.putString("userid", session.userid+"");
              o.putString("nick",session.nick+"");
              o.putString("avatarUrl",session.avatarUrl+"");
              o.putString("topAccessToken",session.topAccessToken+"");
              o.putString("topAuthCode",session.topAuthCode+"");
              o.putString("topExpireTime",session.topExpireTime+"");
            }
            sendEvent(reactApplicationContext,"TBLoginEvent",o);
          } catch (IllegalViewOperationException e) {
            e.printStackTrace();
          }
          break;
//                case NOTIFY_LOGIN_CANCEL:
//                case NOTIFY_LOGIN_FAILED:
//                case NOTIFY_LOGOUT:
//                    break;
        default:
          break;
      }
    }
  };
  /*淘宝登录状态改变监听*/
  private boolean hasRegist = false;
  private void addTBLoginState(){
    IntentFilter mfilter = null;
    // 监听登录状态变化
    try {
      mfilter = new IntentFilter();
      for (LoginAction action : LoginAction.values()) {
        mfilter.addAction(action.name());
      }
      mfilter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
    } catch (Exception e) {
      e.printStackTrace();
    }
    reactContext.registerReceiver(tbLoginReceiver,mfilter);
    hasRegist =true;
  }


  @ReactMethod
  public void destory(Promise promise){
    AlibcTradeSDK.destory();
//        successBack(0,"",promise);
  }

  //获取用户信息
  @ReactMethod
  public void getUserInfo(ReadableMap map,Promise promise) {
    Session session = AlibcLogin.getInstance().getSession();
    if(session == null || !AlibcLogin.getInstance().isLogin()){
      statusBack(false,null,promise);
    }else {
      sessionBack(promise,session);
    }
  }

  @ReactMethod
  public void openByUrl(final int type, ReadableMap map,final Promise promise) {
    openUrlByAli(type, map, promise);
  }

  @ReactMethod
  public void openByBizCode(final int type, ReadableMap map,final Promise promise) {
    openPageByAli(type, map, promise);
  }

  private void openPageByAli(final int type, ReadableMap map,final Promise promise){
    AlibcBasePage page = null;
    Hs_Map paramDict = new Hs_Map(map);
    String code = paramDict.optString("code","");
    switch (type){
      case PAGETYPE_DETAIL:
        String itemId = paramDict.optString("itemId");//真实id/混淆id
        code = TextUtils.isEmpty(code) ? "detail" : code;
        page = new AlibcDetailPage(itemId);
        break;
      case PAGETYPE_SHOP:
        page = new AlibcShopPage(paramDict.optString("shopId"));
        code = TextUtils.isEmpty(code) ? "shop" : code;
        break;
      case PAGETYPE_ADDCART:
        page = new AlibcAddCartPage(paramDict.optString("itemId"));
        code = TextUtils.isEmpty(code) ? "addCart" : code;
        break;
      case PAGETYPE_MYCARTS:
        page = new AlibcMyCartsPage();
        code = TextUtils.isEmpty(code) ? "cart" : code;
        break;
      case PAGETYPE_MYORDERS:
        int status = paramDict.optInt("orderStatus");
        //参数false显示当下appKey的订单
        boolean allOrder = paramDict.optBoolean("allOrder", false);
        code = TextUtils.isEmpty(code) ? "order" : code;
        page = new AlibcMyOrdersPage(status,allOrder);
        break;
      default:
        return;
    }

    AlibcShowParams showParams = getShowParams(map);
    //设置淘客参数
    AlibcTaokeParams taokeParams = getTaokeParam(map);
    //第三方用于跟踪的isvcode
    Map<String, String> exParams = getTrackParams(map);

    AlibcTrade.openByBizCode(getCurrentActivity(), page, null, new WebViewClient(), new WebChromeClient(), code, showParams, taokeParams, exParams, new AlibcTradeCallback() {
      @Override
      public void onTradeSuccess(AlibcTradeResult aliTradeResult) {
        switch (aliTradeResult.resultType){
          case TYPECART:
            successBack(0,"加购成功",promise);
            break;
          case TYPEPAY:
            List<String> list = aliTradeResult.payResult.paySuccessOrders;
            ordersBack(promise,list);
            break;
          default:
            successBack(0,"未知操作，操作成功",promise);
            break;
        }
      }
      @Override
      public void onFailure(int i, String s) {
        failureBack(i,s,promise);
      }
    });
  }

  private void openUrlByAli(final int type, ReadableMap map,final Promise promise){
    Hs_Map paramDict = new Hs_Map(map);
    String url = paramDict.optString("url",paramDict.optString("itemId"));
    if(TextUtils.isEmpty(url)){
      return;
    }
    AlibcShowParams showParams = getShowParams(map);
    //设置淘客参数
    AlibcTaokeParams taokeParams = getTaokeParam(map);
    //第三方用于跟踪的isvcode
    Map<String, String> exParams = getTrackParams(map);
    String kitName = paramDict.optString("identity","");
    AlibcTrade.openByUrl(getCurrentActivity(), kitName, url, null, new WebViewClient(), new WebChromeClient(), showParams, taokeParams, exParams, new AlibcTradeCallback() {
      @Override
      public void onTradeSuccess(AlibcTradeResult aliTradeResult) {
        switch (aliTradeResult.resultType){
          case TYPECART:
            successBack(0,"加购成功",promise);
            break;
          case TYPEPAY:
            List<String> list = aliTradeResult.payResult.paySuccessOrders;
            ordersBack(promise,list);
            break;
          default:
            successBack(0,"未知操作，操作成功",promise);
            break;
        }
      }
      @Override
      public void onFailure(int i, String s) {
        failureBack(i,s,promise);
      }
    });
  }

  /**
   * 商品详情页
   *  支持itemId和openItemId的商品，必填，不允许为null；
   *               eg.37196464781L；AAHd5d-HAAeGwJedwSnHktBI；
   */
  @ReactMethod
  public void showDetailPage(ReadableMap map,final Promise promise) {
    openPageByAli(PAGETYPE_DETAIL,map,promise);
  }

  /**
   * 加入购物车页面
   * itemId 支持itemId和openItemId的商品，必填，不允许为null；
   *               eg.37196464781L；AAHd5d-HAAeGwJedwSnHktBI；
   */
  public void showAddCartPage(ReadableMap map,Promise promise) {
    openPageByAli(PAGETYPE_ADDCART,map,promise);
  }

  /**
   * 我的订单页面
   *
   *  status   默认跳转页面；填写：0：全部；1：待付款；2：待发货；3：待收货；4：待评价
   *  allOrder false 进行订单分域（只展示通过当前app下单的订单），true 显示所有订单
   */
  public void showMyOrders(ReadableMap map,Promise promise) {
    openPageByAli(PAGETYPE_MYORDERS,map,promise);
  }

  public void showMyCarts(ReadableMap map,Promise promise) {
    openPageByAli(PAGETYPE_MYCARTS,map,promise);
  }
  /**
   * 店铺页面
   *  shopId 店铺id，支持明文id
   */
  public void showShopPage(ReadableMap map,Promise promise) {
    openPageByAli(PAGETYPE_SHOP,map,promise);
  }

  public void showPageByUrl(ReadableMap map,Promise promise) {
    openUrlByAli(PAGETYPE_ADDCART,map,promise);
  }

  public static AlibcShowParams getShowParams(ReadableMap map){
    Hs_Map paramDict = new Hs_Map(map);
    AlibcShowParams showParams = new AlibcShowParams();
//        showParams.setOpenType(uzModuleContext.optBoolean("isNative",false) ? OpenType.Native : OpenType.Auto);
    String openType = paramDict.optString("openType","auto");
    //设置购买成功后是否关闭相关联的 activity
    if(TextUtils.equals("auto",openType)){
      showParams = new AlibcShowParams(OpenType.Auto);
    }else if(TextUtils.equals("native",openType)){
      showParams = new AlibcShowParams(OpenType.Native);
    }else{
      showParams = new AlibcShowParams(showParams.getOpenType());
    }

    showParams.setClientType(paramDict.optString("linkKey","taobao"));
    String originalOpenType = paramDict.optString("originalOpenType");
    if(TextUtils.isEmpty(originalOpenType)) {

    }else if(TextUtils.equals("Native",originalOpenType)){
      showParams.setOriginalOpenType(OpenType.Native);
    }else if(TextUtils.equals("Auto",originalOpenType)){
      showParams.setOriginalOpenType(OpenType.Auto);
    }
    //设置购买成功后是否关闭相关联的 activity
    showParams.setPageClose(paramDict.optBoolean("closePage",showParams.isClose()));

    showParams.setTitle(paramDict.optString("title",showParams.getTitle()));
    showParams.setShowTitleBar(paramDict.optBoolean("showTitleBar",showParams.isShowTitleBar()));
    showParams.setProxyWebview(paramDict.optBoolean("proxyWebview",showParams.isProxyWebview()));
    showParams.setBackUrl(paramDict.optString("backUrl",showParams.getBackUrl()));
    String degradeUrl = paramDict.optString("degradeUrl");
    if(!TextUtils.isEmpty(degradeUrl)){
      showParams.setDegradeUrl(degradeUrl);
    }

    String failModeType = paramDict.optString("failModeType");
    if(TextUtils.equals(failModeType,"jumpH5")) {
      showParams.setNativeOpenFailedMode(AlibcFailModeType.AlibcNativeFailModeJumpH5);
    }else if(TextUtils.equals(failModeType,"none")){
      showParams.setNativeOpenFailedMode(AlibcFailModeType.AlibcNativeFailModeNONE);
    }else if(TextUtils.equals(failModeType,"jumpBrower")){
      showParams.setNativeOpenFailedMode(AlibcFailModeType.AlibcNativeFailModeJumpBROWER);
    }else if(TextUtils.equals(failModeType,"jumpDownload")){
      showParams.setNativeOpenFailedMode(AlibcFailModeType.AlibcNativeFailModeJumpDOWNLOAD);
    }else{
      showParams.setNativeOpenFailedMode(showParams.getNativeOpenFailedMode());
    }
    return showParams;
  }
  private AlibcTaokeParams getTaokeParam(ReadableMap map){
    Hs_Map paramDict = new Hs_Map(map);
    String pid = paramDict.optString("pid","");
    String unionId = paramDict.optString("unionId","");
    String subPid = paramDict.optString("subPid","");
    //设置淘客参数
    AlibcTaokeParams taokeParams = new AlibcTaokeParams(pid,unionId,subPid);

//        注：1、如果走adzoneId的方式分佣打点，需要在extraParams中显式传入taokeAppkey，否则打点失败；
    String adzoneid = paramDict.optString("adzoneId",null);
    if (!TextUtils.isEmpty(adzoneid)){
      taokeParams.setAdzoneid(adzoneid);
    }
    Map<String, String> extraParams = paramDict.toHashMap("extraParams") ;
    if (extraParams != null) {
      taokeParams.extraParams = extraParams;
    }
    return taokeParams;
  }
  private Map<String, String> getTrackParams(ReadableMap map){
    Hs_Map paramDict = new Hs_Map(map);
    String appIsvCode = paramDict.optString("isvCode");
    Map<String, String> exParams;
    if (!TextUtils.isEmpty(appIsvCode)){
      boolean isvok = AlibcTradeSDK.setISVCode(appIsvCode);
    }
    Map<String, String> trackParams = paramDict.toHashMap("trackParams") ;
    if (trackParams !=null){
      //第三方用于跟踪的isvcode
      exParams =  trackParams;
    }else{
      exParams = null;
    }
    return exParams;
  }

  private void ordersBack(Promise promise, List<String> ordersId) {
    WritableMap ret = Arguments.createMap();
    try {
      ret.putBoolean("status", true);
      ret.putArray("ordersId", (WritableArray) ordersId);
      promise.resolve(ret);
    } catch (IllegalViewOperationException e) {
      e.printStackTrace();
    }
  }

  private void sessionBack(Promise promise, Session session) {
    WritableMap ret = Arguments.createMap();
    try {
      ret.putBoolean("status", true);
      ret.putString("nick", session.nick);
      ret.putString("avatarUrl", session.avatarUrl);
      ret.putString("openSid", session.openSid);
      ret.putString("openId", session.openId);
      ret.putString("userid", session.userid);
      ret.putString("topAccessToken",session.topAccessToken+"");
      ret.putString("topAuthCode",session.topAuthCode+"");
      ret.putString("topExpireTime",session.topExpireTime+"");
      ret.putString("ssoToken",session.ssoToken+"");
      ret.putString("havanaSsoToken",session.havanaSsoToken+"");
      ret.putBoolean("isLogin", AlibcLogin.getInstance().isLogin());
      promise.resolve(ret);
    } catch (IllegalViewOperationException e) {
      e.printStackTrace();
      promise.reject(e);
    }
  }
  private void statusBack(boolean isOk, String msg, Promise promise) {
    WritableMap ret = Arguments.createMap();
    try {
      ret.putBoolean("status", isOk);
      if (!TextUtils.isEmpty(msg)){
        ret.putString("message", msg);
      }
      promise.resolve(ret);
    } catch (IllegalViewOperationException e) {
      e.printStackTrace();
      promise.reject(e);
    }
  }
  private void successBack(int i, @Nullable String msg, Promise promise) {
    WritableMap ret = Arguments.createMap();
    try {
      ret.putBoolean("status", true);
      ret.putInt("code", i);
      if (!TextUtils.isEmpty(msg)){
        ret.putString("message", msg);
      }
      promise.resolve(ret);
    } catch (IllegalViewOperationException e) {
      e.printStackTrace();
      promise.reject(e);
    }
  }
  private void failureBack(int i, @Nullable String msg, Promise promise) {
    WritableMap err = Arguments.createMap();
    try {
      err.putBoolean("status", false);
      err.putInt("code", i);
      if (!TextUtils.isEmpty(msg)){
        err.putString("message", msg);
      }
      promise.resolve(err);
    } catch (IllegalViewOperationException e) {
      e.printStackTrace();
      promise.reject(e);
    }
  }
}