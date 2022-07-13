import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialmediaapp/res/styles.dart';
import 'package:socialmediaapp/utils/call_manager.dart';
import 'package:uuid/uuid.dart';
class CallScreen extends StatefulWidget {
   CallScreen(this.userId, this.username, this.deviceToken, {Key? key}) : super(key: key);
String userId;
String username;
String deviceToken;
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  RtcEngine? _engine;
  Timer? _timer;
  var callListener;
  static const appId = "4b609511d6724c2292ebc74a26a22b87";
  static const token="0064b609511d6724c2292ebc74a26a22b87IAC+Hgbb4aYEnYb0+hy/FJRvSSf3FpIXcnt9Kxw9suFkte3d+UgAAAAAEACQKMvtG3TOYgEAAQAbdM5i";
  String channel = "prateekm26";
  /// for knowing if the current user joined
  /// the call channel.
  bool joined = false;
  /// the remote user id.
  String? remoteUid;
  /// if microphone is opened.
  bool openMicrophone = true;
  /// if the speaker is enabled.
  bool enableSpeakerphone = true;
  /// if call sound play effect is playing.
  bool playEffect = true;
  /// the call document reference.
  DocumentReference? callReference;
  /// call time made.
  int callTime = 0;
  /// if the call was accepted
  /// by the remove user.
  bool callAccepted = false;
  /// if callTime can be increment.
  bool canIncrement = true;

  ///call timer
  void startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (mounted) {
        if (canIncrement) {
          setState((){
            callTime += 1;
          });
        }
      }
    });
  }

///turn microphone on/off
  void switchMicrophone() {
    _engine?.enableLocalAudio(!openMicrophone).then((value) {
      setState((){
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      debugPrint("enableLocalAudio: $err");
    });
  }

  ///turn speaker on/off
  void switchSpeakerphone() {
    _engine?.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState((){
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      debugPrint("enableSpeakerphone: $err");
    });
  }

  ///switch effect
  Future<void> switchEffect() async {
    if (playEffect) {
      _engine?.stopEffect(1).then((value) {
        setState((){
          playEffect = false;
        });
      }).catchError((err) {
        debugPrint("stopEffect $err");
      });
    } else {
      _engine?.playEffect(
        1,
        File("assets/sounds/call_ring.mp3").path,
        -1,
        1,
        1,
        100,
        true,
      ).then((value) {
        setState((){
          playEffect = true;
        });
      }).catchError((err) {
        debugPrint("playEffect $err");
      });
    }
  }

  Future<void> initRtcEngine() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    final String channelName = const Uuid().v4();
    /// Create RTC client instance
    //app id
    _engine = await RtcEngine.create("4b609511d6724c2292ebc74a26a22b87");

    /// Define event handler
    _engine?.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) async {
        debugPrint('joinChannelSuccess $channel $uid');
        if (mounted) setState((){
          joined = true;
        });
        callReference = await CallManager.instance.createCall("prateekm26",token,widget.userId,widget.deviceToken);
        print("Call reference-------${callReference!.id}");
        switchEffect();
        callListener = await FirebaseFirestore.instance.collection("calls").doc(callReference!.id).snapshots().listen((data){
          if (!data.exists) {
            /// tell the user that the call was cancelled
            Navigator.of(context).pop();
            return;
          }
        });
      },
      leaveChannel: (stats) {
        debugPrint("leaveChannel ${stats.toJson()}");
        if (mounted) setState((){
          joined = false;
        });
      },
      userJoined: (int uid, int elapsed) {
        debugPrint('userJoined $uid');
        setState((){
          remoteUid = uid.toString();
        });
        switchEffect();
        setState((){
          if (!canIncrement) canIncrement = true;
          callAccepted = true;
        });
        startTimer();
      },
      userOffline: (int uid, UserOfflineReason reason) {
        debugPrint('userOffline $uid');
        setState((){
          remoteUid = null;
          canIncrement = false;
        });
        switchEffect();
      },
    ));
    _engine?.enableAudio();
    _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    _engine?.setClientRole(ClientRole.Broadcaster);

    await _engine?.joinChannel(token, channel, null, 0);
  }
  @override
  void initState() {
    super.initState();
    initRtcEngine();
  }

  @override
  Widget build(BuildContext context) {
    return _mainWidget();
  }

  Widget _mainWidget() {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0,bottom: 50),
          child: Column(
              children:[
                 Text("${widget.username}",style: AppStyles.blackBold32,),
                 SizedBox(height: 20,),
                 Text("Calling..."),
                const Spacer(),
                Center(
                  child: ElevatedButton(onPressed: (){
                    _engine?.destroy();
                    CallManager.instance.deleteCalls(widget.userId);
                    Navigator.pop(context);
                  }, child: const Text("End")),
                )
              ]
          ),
        ),
      ),

    );
  }
}
