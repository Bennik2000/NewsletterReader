package de.bennik2000.newsletter_reader;

import android.os.Bundle;
import android.util.Log;

import de.bennik2000.newsletter_reader.platform.NativePdfToImageRenderer;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    ((Application) getApplication()).registerMethodChannels(
            registrarFor("de.bennik2000.newsletter_reader").messenger());
  }
}
