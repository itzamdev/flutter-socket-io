import Flutter
import UIKit
import SocketIO

public class SwiftItzamSocketIoPlugin: NSObject, FlutterPlugin, WSDelegate {
    
    // delegate method to listen the ws events
    func onWS(eventName: String, data: [Any]) {
        
        print("socketIO: onEvent  \(eventName)")
        self.channel!.invokeMethod("incoming", arguments: [
            "eventName": eventName, "data":data[0]
        ]);
    }
    
    var channel: FlutterMethodChannel?
    let ws = WS()
    
    
    public init(_ channel:FlutterMethodChannel) {
        super.init()
        self.channel = channel
        self.ws.delegate = self
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "itzam_socket_io", binaryMessenger: registrar.messenger())
        let instance = SwiftItzamSocketIoPlugin(channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] // get params
        
        switch call.method{
        case "connect":
            print("socketIO connecting")
           
            self.ws.connect(args: args!)// connect to ws
            result(nil)
            
            
        case "disconnect":
            print("socketIO disconnected")
            self.ws.disconnect()//disconnect to ws
            //self.ws = nil
            result(nil)
            
        case "on":
            let eventName: String = args?["eventName"] as! String
            print("socketIO eventName \(eventName)")
            self.ws.on(eventName: eventName)
            result(nil)
            
        case "emit":
            let eventName: String = args?["eventName"] as! String
            let data = args?["data"] as Any
            self.ws.emit(eventName: eventName,dataTosend: data)
            
        default:
            result(FlutterError(code: "404", message: "No such method", details: nil))
        }
        
    }
}




protocol WSDelegate: class {
    func onWS(eventName:String,data:[Any])
}


class WS: NSObject{
    
    
    private var socketManager: SocketManager?
    private var socket : SocketIOClient?
    private var socketId: String?
    weak var delegate: WSDelegate?
    
    
    
    
    func connect(args: [String: Any])  {
        
        
        let host: String = args["host"] as! String // socket-io host
        
        let query: [String : Any] = args["query"] as! [String : Any]
        
        
        
        
        //socket manager to connnect with socket-io
        
        self.socketManager = SocketManager(socketURL: URL(string: host)!,config: [.log(true), .forcePolling(true), .connectParams(query),.reconnects(true),.forceNew(true)])
        
        self.socket = socketManager?.defaultSocket
        
        
        self.socket?.on(clientEvent: .connect) {data, ack in
            print("socketIO: connect ")
            self.delegate?.onWS(eventName: "connect", data: ["connected to SOCKET-IO server"])
        }
        
        self.socket?.on(clientEvent: .error) {data, ack in
            print("socketIO: error \(data)")
            self.delegate?.onWS(eventName: "error", data: data)
        }
        
        
        self.socket?.on(clientEvent: .reconnect) {data, ack in
            print("socketIO: reconnect")
            self.delegate?.onWS(eventName: "reconnect", data: ["begins the reconnection process"])
        }
        
        
        self.socket?.on(clientEvent: .disconnect) {data, ack in
            print("socketIO: disconnect")
            self.delegate?.onWS(eventName: "disconnect", data: ["disconnected from your SOCKET-IO server"])
        }
        
        self.socket?.connect()
        
    }
    
    
    //this method is used to listen the websockets listeners
    func on(eventName: String) {
        self.socket?.on(eventName) {data, ack in
            print("socketIO: on \(eventName) ")
            self.delegate?.onWS(eventName: eventName, data: data)
        }
    }
    
    func emit(eventName:String, dataTosend: Any){
        print("socketIO: emit \(eventName) ")
        self.socket?.emit(eventName, with: [dataTosend])//send data to websockets
    }
    
    
    func disconnect() {
   
        self.socket?.disconnect()
    }
    
}

