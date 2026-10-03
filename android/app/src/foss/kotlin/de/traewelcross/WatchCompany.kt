package de.traewelcross
import io.flutter.plugin.common.MethodChannel

class WatchCompany {
    companion object {
        fun transferToWatch(token: String, activity: MainActivity, result: MethodChannel.Result) {
            result.error("NO_GPS", null, null);
        }
    }
}