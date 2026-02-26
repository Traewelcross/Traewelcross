package de.traewelcross

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var overrideVolumeBtns = false
    private lateinit var channel : MethodChannel;
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "volume");
        channel.setMethodCallHandler { call, result -> if(call.method == "setOverrideStatus"){
            overrideVolumeBtns = call.argument<Boolean>("val") == true
        } }
    }
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if(overrideVolumeBtns){
            when (keyCode) {
                KeyEvent.KEYCODE_VOLUME_DOWN -> channel.invokeMethod("volumePressed", "down")
                KeyEvent.KEYCODE_VOLUME_UP -> channel.invokeMethod("volumePressed", "up")
            }
            return true
        }
        return super.onKeyDown(keyCode, event)
    }
}
