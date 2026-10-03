package de.traewelcross

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var overrideVolumeBtns = false
    private lateinit var volChannel : MethodChannel;
    private lateinit var watchChannel : MethodChannel;
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        volChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "volume");
        volChannel.setMethodCallHandler { call, result -> if(call.method == "setOverrideStatus"){
            overrideVolumeBtns = call.argument<Boolean>("val") == true
        } }
        watchChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "watchChannel")
        watchChannel.setMethodCallHandler { call, result ->  if(call.method == "transferToken"){
            WatchCompany.transferToWatch(call.argument<String>("token")!!, this, result)
        } }
    }
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if(overrideVolumeBtns){
            when (keyCode) {
                KeyEvent.KEYCODE_VOLUME_DOWN -> volChannel.invokeMethod("volumePressed", "down")
                KeyEvent.KEYCODE_VOLUME_UP -> volChannel.invokeMethod("volumePressed", "up")
                else -> super.onKeyDown(keyCode, event)
            }
            return true
        }
        return super.onKeyDown(keyCode, event)
    }
}
