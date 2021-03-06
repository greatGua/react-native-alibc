package com.inshare.alibc.events;

import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event
import com.facebook.react.uimanager.events.RCTEventEmitter

class TopTradeSuccessEvent(viewId: Int, private val mEventData: WritableMap) :
        Event<TopTradeSuccessEvent>(viewId) {
    companion object {
        const val EVENT_NAME = "topTradeSuccess"
    }

    override fun getEventName(): String = EVENT_NAME

    override fun canCoalesce(): Boolean = false

    override fun getCoalescingKey(): Short = 0

    override fun dispatch(rctEventEmitter: RCTEventEmitter) =
            rctEventEmitter.receiveEvent(viewTag, eventName, mEventData)

}