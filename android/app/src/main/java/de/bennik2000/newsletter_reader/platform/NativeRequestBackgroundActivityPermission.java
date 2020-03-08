package de.bennik2000.newsletter_reader.platform;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.PowerManager;
import android.provider.Settings;

import de.bennik2000.newsletter_reader.Application;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;

public class NativeRequestBackgroundActivityPermission {
    private static final String NativeRequestBackgroundActivityPermissionChannel
            = "native/NativeRequestBackgroundActivityPermission";

    private Context context;

    public NativeRequestBackgroundActivityPermission(Context context) {
        this.context = context;
    }


    public void setupMethodChannel(BinaryMessenger messenger) {
        new MethodChannel(messenger, NativeRequestBackgroundActivityPermissionChannel)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("requestBackgroundActivity")) {
                                requestBackgroundActivity(call, result);
                            }
                        });
    }

    private void requestBackgroundActivity(
            MethodCall call,
            MethodChannel.Result result) {

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            String packageName = context.getPackageName();
            PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                Intent intent = new Intent();
                intent.setAction(android.provider.Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setFlags(FLAG_ACTIVITY_NEW_TASK);
                intent.setData(Uri.parse("package:" + packageName));
                context.startActivity(intent);
            }
        }

        result.success(null);
    }
}