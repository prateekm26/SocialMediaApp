
import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:socialmediaapp/res/styles.dart';
import 'package:socialmediaapp/utils/call_manager.dart';

class CallReceiveScreen extends StatefulWidget {
   CallReceiveScreen( {Key? key}) : super(key: key);
  /*QueryDocumentSnapshot<Map<String, dynamic>> call;*/

  @override
  State<CallReceiveScreen> createState() => _CallReceiveScreenState();
}

class _CallReceiveScreenState extends State<CallReceiveScreen> {
  RtcEngine? engine;
  Timer? _timer;
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
  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer.playRingtone();
  }

  Future<void> acceptCall() async {
    FlutterRingtonePlayer.stop();
    setState(() {
      callAccepted=true;
    });
    ///call token
    //const callToken="0064b609511d6724c2292ebc74a26a22b87IACgyAl6z+NyNnSzftU0w/ZFQMO8fi37GVJKUZDf7WNCDu3d+UgAAAAAEABC+vTdfZHGYgEAAQB9kcZi";
    ///final String callToken = "";/*await getAgoraChannelToken(chatId)*//*
String? callToken=receiveCalls.value.call!.first.token;
    if (callToken == null){
      // nothing will be done
      return;
    }

    // Create RTC client instance
    engine = await RtcEngine.create("4b609511d6724c2292ebc74a26a22b87");///appId
    // Define event handler
    engine?.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) async {
        debugPrint('joinChannelSuccess $channel $uid');
        joined = true;
        startTimer();
      },
      leaveChannel: (stats) {
        debugPrint("leaveChannel ${stats.toJson()}");
        joined = false;
      },
      userJoined: (int uid, int elapsed) {
        debugPrint('userJoined $uid');
        remoteUid = uid.toString();
        if (playEffect) switchEffect();
        if (!canIncrement) canIncrement = true;
      },
      userOffline: (int uid, UserOfflineReason reason) {
        debugPrint('userOffline $uid');
        remoteUid = null;
        canIncrement = false;
        switchEffect();
      },
    ));
    engine?.enableAudio();
    engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    engine?.setClientRole(ClientRole.Broadcaster);
// Join channel
    await engine?.joinChannel(callToken, "prateekm26", null, 0);
  }
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

  ///switch effect
  Future<void> switchEffect() async {
    if (playEffect) {
      engine?.stopEffect(1).then((value) {
        setState((){
          playEffect = false;
        });
      }).catchError((err) {
        debugPrint("stopEffect $err");
      });
    } else {
      engine?.playEffect(
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
  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children:[
              Text(receiveCalls.value.call?.first.senderName??"",style: AppStyles.blackBold32),
              Text("Incoming..."),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  callAccepted?Container(): ElevatedButton(onPressed: (){
                    acceptCall();}, child: Text("Accept")),
                  ElevatedButton(onPressed: (){
                    FlutterRingtonePlayer.stop();
                    engine?.destroy();
                  CallManager.instance.deleteCalls(receiveCalls.value.call!.first.receiverId!);
                  }, child: Text("Decline")),
                ],
              )
            ]
          ),
        ),
      ),

    );
  }
}

