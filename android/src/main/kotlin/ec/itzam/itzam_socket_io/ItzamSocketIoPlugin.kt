package ec.itzam.itzam_socket_io

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class ItzamSocketIoPlugin(private val channel: MethodChannel) : MethodCallHandler, WS.OnWS {

    override fun onWS(eventName: String) {
        val handler = Handler(Looper.getMainLooper())

        handler.post {
            val arguments = HashMap<String, String>()
            arguments.put("eventName", eventName)
            channel.invokeMethod("incoming", arguments)
        }
    }

    override fun onWS(eventName: String, data: String) {
        val handler = Handler(Looper.getMainLooper())

        handler.post {
            val arguments = HashMap<String, String>()
            arguments.put("eventName", eventName)
            arguments.put("data", data)
            channel.invokeMethod("incoming", arguments)
        }
    }


    private var ws: WS? = null

    init {

    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "itzam_socket_io")
            channel.setMethodCallHandler(ItzamSocketIoPlugin(channel))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "connect" -> {
                val host = call.argument<String>("host")
                val params = call.argument<String>("params")
                ws = WS()
                ws?.onWS = this
                ws?.connect(host!!, params!!)
                result.success(null)
            }

            call.method == "disconnect" -> {
                ws?.disconnect()
                ws = null
                result.success(null)
            }

            call.method == "on" -> {
                val eventName = call.argument<String>("eventName")
                ws?.on(eventName!!)
                result.success(null)
            }

            call.method == "emit" -> {
                val eventName = call.argument<String>("eventName")
                val data = call.argument<Any>("data")
                ws?.emit(eventName!!, data!!)
                result.success(null)
            }
        }
    }
}
