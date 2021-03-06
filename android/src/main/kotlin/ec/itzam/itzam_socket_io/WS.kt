package ec.itzam.itzam_socket_io


import android.util.Log
import io.socket.client.IO
import io.socket.client.Socket
import io.socket.emitter.Emitter
import org.json.JSONException
import java.lang.Exception
import org.json.JSONObject


class WS {


    private var socket: Socket? = null
    var onWS: OnWS? = null

    fun connect(host: String, query: String) {


        try {
            val options = IO.Options()
            options.query = query
            options.forceNew = true

            socket = IO.socket(host, options)
            socket!!.connect()

            socket!!.on("connect") { args -> onWS!!.onWS("connect", "connected to SOCKET-IO server") }
            socket!!.on("disconnect") { args -> onWS!!.onWS("disconnect", "disconnected from your SOCKET-IO server") }
            socket!!.on("error") { args -> onWS!!.onWS("error", args[0].toString()) }
            socket!!.on("reconnect") { args -> onWS!!.onWS("reconnect", "begins the reconnection process") }

        } catch (e: Exception) {
            Log.e("SOCKET_IO:", e.message)
        }

    }


    fun emit(eventName: String, data: Any) {
        if (socket != null) {
            if (data is HashMap<*, *>) {

                socket!!.emit(eventName, JSONObject(data));
            } else if (data is String) {

                socket!!.emit(eventName, data);
            } else {
                socket!!.emit(eventName, data);
            }
        }
    }

    fun on(eventName: String) {

        socket!!.on(eventName) { args ->
            if (args[0] != null) {
                onWS!!.onWS(eventName, args[0].toString())
            } else {
                onWS!!.onWS(eventName)
            }
        }


    }


    fun disconnect() {
        if (socket != null) {
            onWS!!.onWS("disconnected", "disconnected from your SOCKET-IO server")
            socket!!.off("off");
            socket!!.disconnect();
            socket = null
        }
    }


    interface OnWS {
        fun onWS(eventName: String, data: String)
        fun onWS(eventName: String)
    }


}