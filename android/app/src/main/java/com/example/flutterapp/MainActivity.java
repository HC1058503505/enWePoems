package com.example.flutterapp;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.CustomFlutterPlugins;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.HttpGet;
import io.flutter.plugins.MD5;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        CustomFlutterPlugins.registerLogger(getFlutterView());
        MD5.md5(getFlutterView());
        HttpGet.get(getFlutterView());
    }
}
