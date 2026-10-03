package de.traewelcross

import android.util.Log
import android.widget.Toast
import com.google.android.gms.wearable.Wearable
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import java.nio.charset.StandardCharsets

class WatchCompany {
    companion object {
        fun transferToWatch(token: String, activity: MainActivity, result: MethodChannel.Result) {
            CoroutineScope(Dispatchers.IO).launch {
                val nodeClient = Wearable.getNodeClient(activity)
                val messageClient = Wearable.getMessageClient(activity)
                val connectedNodes = nodeClient.connectedNodes.await()
                if(connectedNodes.isEmpty()){
                    Toast.makeText(activity.context, "No watches found :(", Toast.LENGTH_LONG).show()
                    result.error("NO_WATCHES", null, null)
                    return@launch
                }
                val payload = token.toByteArray(StandardCharsets.UTF_8)
                for (node in connectedNodes){
                    val req = messageClient.sendMessage(node.id, "/traewelcrosswearauth", payload).await()
                    Log.i(null, "Sent to " + node.displayName + " / " +node.id + " : " + node.toString())
                }
                Log.i(null, "success")
                result.success("SUCCESS")
            }
        }
    }
}