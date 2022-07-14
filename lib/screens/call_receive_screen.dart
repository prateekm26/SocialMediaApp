import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:socialmediaapp/res/styles.dart';
import 'package:socialmediaapp/utils/call_manager.dart';
import 'package:socialmediaapp/utils/colors.dart';
import 'package:socialmediaapp/widgets/app_buttons.dart';

class CallReceiveScreen extends StatefulWidget {
  CallReceiveScreen({Key? key}) : super(key: key);

  @override
  State<CallReceiveScreen> createState() => _CallReceiveScreenState();
}

class _CallReceiveScreenState extends State<CallReceiveScreen> {
  RtcEngine? _engine;
  Timer? _timer;

  /// for knowing if the current user joined
  /// the call channel.
  bool joined = false;

  /// the remote user id.
  String? remoteUid;

  /// if microphone is opened.
  bool openMicrophone = true;

  /// if the speaker is enabled.
  bool enableSpeakerphone = false;

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

  ///turn microphone on/off
  void switchMicrophone() {
    _engine?.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      debugPrint("enableLocalAudio: $err");
    });
  }

  ///turn speaker on/off
  void switchSpeakerphone() {
    _engine?.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      debugPrint("enableSpeakerphone: $err");
    });
  }

  Future<void> acceptCall() async {
    FlutterRingtonePlayer.stop();
    setState(() {
      callAccepted = true;
    });

    ///call token
    //const callToken="0064b609511d6724c2292ebc74a26a22b87IACgyAl6z+NyNnSzftU0w/ZFQMO8fi37GVJKUZDf7WNCDu3d+UgAAAAAEABC+vTdfZHGYgEAAQB9kcZi";
    ///final String callToken = "";/*await getAgoraChannelToken(chatId)*//*
    String? callToken = receiveCalls.value.call!.first.token;
    if (callToken == null) {
      // nothing will be done
      return;
    }

    // Create RTC client instance
    _engine = await RtcEngine.create("4b609511d6724c2292ebc74a26a22b87");

    ///appId
    // Define event handler
    _engine?.setEventHandler(RtcEngineEventHandler(
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
    _engine?.enableAudio();
    _engine?.setEnableSpeakerphone(enableSpeakerphone);
    _engine?.setChannelProfile(ChannelProfile.Communication);
    _engine?.setClientRole(ClientRole.Broadcaster);
// Join channel
    await _engine?.joinChannel(callToken, "prateekm26", null, 0);
  }

  ///call timer
  void startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (mounted) {
        if (canIncrement) {
          setState(() {
            callTime += 1;
          });
        }
      }
    });
  }

  ///switch effect
  Future<void> switchEffect() async {
    if (playEffect) {
      _engine?.stopEffect(1).then((value) {
        setState(() {
          playEffect = false;
        });
      }).catchError((err) {
        debugPrint("stopEffect $err");
      });
    } else {
      _engine
          ?.playEffect(
        1,
        File("assets/sounds/call_ring.mp3").path,
        -1,
        1,
        1,
        100,
        true,
      )
          .then((value) {
        setState(() {
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
          padding:
              const EdgeInsets.only(top: 50.0, bottom: 80, left: 40, right: 40),
          child: Column(children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.mainColor),
              child: Center(
                  child: Text(
                receiveCalls.value.call!.first.senderName!.toUpperCase()[0],
                style: AppStyles.whiteBold32,
              )),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(receiveCalls.value.call?.first.senderName ?? "",
                style: AppStyles.blackBold32),
            const SizedBox(
              height: 10,
            ),
            Text(callAccepted
                ? intToTimeLeft(callTime).toString()
                : "Incoming..."),
            const Spacer(),
            callAccepted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            switchSpeakerphone();
                          },
                          child: CircularButton(
                              Icons.volume_up_sharp,
                              enableSpeakerphone
                                  ? AppColors.mainColor
                                  : AppColors.inactiveBtnColor)),
                      InkWell(
                          onTap: () {
                            _engine?.destroy();
                            CallManager.instance.deleteCalls(
                                receiveCalls.value.call!.first.receiverId!);
                          },
                          child: CircularButton(Icons.call_end,
                              AppColors.danger) //const RoundedButton()
                          ),
                      InkWell(
                          onTap: () {
                            switchMicrophone();
                          },
                          child: CircularButton(
                              Icons.mic_off,
                              openMicrophone
                                  ? AppColors.inactiveBtnColor
                                  : AppColors.mainColor)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            acceptCall();
                          },
                          child: CircularButton(  //accept call
                            Icons.call,
                            AppColors.success,
                            height: 80,
                            width: 80,
                          )
                          ),
                      InkWell(
                          onTap: () {
                            FlutterRingtonePlayer.stop();
                            _engine?.destroy();
                            CallManager.instance.deleteCalls(
                                receiveCalls.value.call!.first.receiverId!);
                          },
                          child: CircularButton( //decline call
                            Icons.call_end,
                            AppColors.danger,
                            height: 80,
                            width: 80,
                          )
                          )
                    ],
                  )
          ]),
        ),
      ),
    );
  }

  ///call running time in hh:mm:ss
  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }
}
