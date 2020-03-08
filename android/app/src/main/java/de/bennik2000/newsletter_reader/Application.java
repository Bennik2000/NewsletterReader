package de.bennik2000.newsletter_reader;

import android.util.Log;

import com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin;

import de.bennik2000.newsletter_reader.platform.NativePdfToImageRenderer;
import de.bennik2000.newsletter_reader.platform.NativeRequestBackgroundActivityPermission;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class Application extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    NativePdfToImageRenderer nativePdfToImageRenderer = new NativePdfToImageRenderer(this);
    NativeRequestBackgroundActivityPermission nativeRequestBackgroundActivityPermission = new NativeRequestBackgroundActivityPermission(this);

    @Override
    public void onCreate() {
        super.onCreate();
        BackgroundFetchPlugin.setPluginRegistrant(this);

        Log.d("NewsletterReader", "onCreate");


    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);

        Log.d("NewsletterReader", "Registering native");

        BinaryMessenger messenger = registry.registrarFor("de.bennik2000.newsletter_reader").messenger();

        registerMethodChannels(messenger);
    }

    public void registerMethodChannels(BinaryMessenger messenger){

        Log.d("NewsletterReader", "Registering native");

        try {
            nativePdfToImageRenderer.setupMethodChannel(messenger);
        }
        catch (Exception e){
            e.printStackTrace();
        }

        try {
            nativeRequestBackgroundActivityPermission.setupMethodChannel(messenger);
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
}
