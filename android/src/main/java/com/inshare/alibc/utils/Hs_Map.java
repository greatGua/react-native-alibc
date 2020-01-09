package com.inshare.alibc.utils;


import com.facebook.react.bridge.Dynamic;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class Hs_Map {
    private ReadableMap c;
    public Hs_Map(ReadableMap map){
        this.c = map;
    }

    public final int optInt(String key) {
        return this.c != null ? this.c.getInt(key) : 0;
    }

    public final int optInt(String key, int fallback) {
        return this.c.hasKey(key) ? this.c.getInt(key) : fallback;
    }

    public final String optString(String key) {
        return this.c != null ? this.c.getString(key) : "";
    }

    public final String optString(String key, String fallback) {
        return this.c.hasKey(key) ? this.c.getString(key) : fallback;
    }

    public final boolean optBoolean(String key) {
        return this.c != null && this.c.getBoolean(key);
    }

    public final boolean optBoolean(String key, boolean fallback) {
        return this.c.hasKey(key) ? this.c.getBoolean(key) : fallback;
    }

    public final double optDouble(String key) {
        return this.c != null ? this.c.getDouble(key) : 0.0D / 0.0;
    }

    public final double optDouble(String key, double fallback) {
        return this.c.hasKey(key) ? this.c.getDouble(key) : fallback;
    }

    public final Dynamic optDynamic(String key) {
        return this.c != null ? this.c.getDynamic(key) : null;
    }

    public final Dynamic optDynamic(String key, Object fallback) {
        return this.c.hasKey(key) ? this.c.getDynamic(key) : (Dynamic) fallback;
    }

    public final ReadableType optType(String key) {
        return this.c != null ? this.c.getType(key) : ReadableType.Null;
    }

    public final ReadableType optType(String key, ReadableType fallback) {
        return this.c.hasKey(key) ? this.c.getType(key) : fallback;
    }

    public final ReadableMap optReadableMap(String key) {
        return this.c != null ? this.c.getMap(key) : null;
    }

    public final ReadableArray optReadableArray(String key) {
        return this.c != null ? this.c.getArray(key) : null;
    }

    public final boolean isNull(String name) {
        return this.c != null ? this.c.isNull(name) : true;
    }

    public HashMap<String, String> toHashMap(String mapKey){
        ReadableMap map = this.optReadableMap(mapKey);
        if(map == null) return null;
        Map<String, Object> backMap = map.toHashMap();
        HashMap<String, String> valueMap = new HashMap<>();
        try{
            String key;
            String value;
            Iterator<String> keyIter = backMap.keySet().iterator();
            while (keyIter.hasNext()) {
                key = keyIter.next();
                value = (String) backMap.get(key);
                valueMap.put(key, value);
            }
            return valueMap;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
