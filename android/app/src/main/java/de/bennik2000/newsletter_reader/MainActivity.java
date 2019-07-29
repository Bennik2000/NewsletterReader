package de.bennik2000.newsletter_reader;

import android.os.Bundle;

import de.bennik2000.newsletter_reader.platform.NativePdfToImageRenderer;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private NativePdfToImageRenderer nativePdfToImageRenderer;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    nativePdfToImageRenderer = new NativePdfToImageRenderer(this);
    nativePdfToImageRenderer.setupMethodChannel(getFlutterView());
  }
}
