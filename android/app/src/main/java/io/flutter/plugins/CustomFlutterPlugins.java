package io.flutter.plugins;

import android.util.Log;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class CustomFlutterPlugins {

    //这里必选要跟Flutter平台名称对应上，否则无法接收消息
    private static final String LOG_CHANNEL_NAME = "com.yancy.flutter.plugins/log";
    public static void registerLogger(BinaryMessenger messenger) {
        new MethodChannel(messenger, LOG_CHANNEL_NAME).setMethodCallHandler((methodCall, result) -> {
            String tag = methodCall.argument("tag");
            String msg = methodCall.argument("msg");
            switch (methodCall.method) {
                case "logV":
                    Log.v(tag, msg);
                    break;
                case "logD":
                    Log.d(tag, msg);
                    break;
                case "logI":
                    Log.i(tag, msg);
                    break;
                case "logW":
                    Log.w(tag, msg);
                    break;
                case "logE":
                    Log.e(tag, msg);
                    break;
                default:
                    Log.d(tag, msg);
                    break;
            }
        });
    }

}
