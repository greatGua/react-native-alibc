import { Component } from 'react';
// eslint-disable-next-line
import { IOSWebViewProps, AndroidWebViewProps } from './lib/AliBCWebViewTypes';

export { WebViewMessageEvent, WebViewNavigation } from "./lib/AliBCWebViewTypes";

export type WebViewProps = IOSWebViewProps & AndroidWebViewProps;

declare class AliBCWebView extends Component<WebViewProps> {
    /**
     * Go back one page in the webview's history.
     */
    goBack: () => void;

    /**
     * Go forward one page in the webview's history.
     */
    goForward: () => void;

    /**
     * Reloads the current page.
     */
    reload: () => void;

    /**
     * Stop loading the current page.
     */
    stopLoading(): void;

    /**
     * Extra Native Component Config.
     */
    extraNativeComponentConfig: () => any;

    /**
     * Executes the JavaScript string.
     */
    injectJavaScript: (script: string) => void;

    /**
     * Focuses on WebView redered page.
     */
    requestFocus: () => void;
}

interface ITaokeParam{
    pid?: string;
    unionId?: string;
    subPid?: string;
    adzoneId?: string;
    extraParams?: {
         [name: string]: any
    }
}

interface IShowParam{
    openType?: "auto" | "native";
    linkKey?: "taobao" | "tmall";
    title?: string;
    showTitleBar?: boolean;
    backUrl?: string;//tbopen+appkey
    degradeUrl?: string;
    failModeType?: "jumpH5" | "none" | "jumpBrower" | "jumpDownload";
}

interface ITrackParam{
    isvCode?: string;
    trackParams?: {
        [name: string]: any
   }
}

export interface RNAliBCStatic {
    setDebug(map: {
        debug?: boolean //默认false
    }): Promise<>;

    asyncInit(map: {
        debug?: boolean; //默认false
    }): Promise<>;

    setIsAuthVip(map: {
        isVip?: boolean //默认true
    }): void;

    setSyncForTaoke(map: {
        isSyncForTaoke?: boolean //默认true
    }): Promise<>;

    setUseAlipayNative(map: {
        isShould?: boolean //默认true
    }): void;

    setChannel(map: {
        typeName?: string;
        channelName?: string;
    }): Promise<>;

    setIsvCode(map: {
        code: string
    }): Promise<>;

    setIsvVersion(map: {
        version: string;
    }): void;

    setTaokeParams(map: ITaokeParam): Promise<>;

    unregisterTbBrodcast(): void;

    showLogin(): Promise<>;

    logout(): Promise<>;

    destory(): void;

    getUserInfo(): Promise<>;

    openByUrl(map: {
        url: string;
        identity?: string;
    } & ITaokeParam & IShowParam & ITrackParam): Promise<>;

    openByBizCode(type: 0 | 1 | 2 | 3 | 4, map: {
        code?: string;
        itemId?: string;
        shopId?: string;
        orderStatus?: number;
        allOrder?: boolean
    } & ITaokeParam & IShowParam & ITrackParam): Promise<>;

    TYPE_DETAIL: 0;
    TYPE_SHOPE: 1;
    TYPE_ADDCART: 2;
    TYPE_MYORDERS: 3;
    TYPE_MYCARTS: 4;
}

const RNAliBC: RNAliBCStatic;
export type RNAliBC = RNAliBCStatic;

export {AliBCWebView};
export default RNAliBC;
