import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialmediaapp/Models/call_receive_model.dart';
import 'package:socialmediaapp/res/styles.dart';
import 'package:socialmediaapp/utils/app_buttons.dart';
import 'package:socialmediaapp/utils/call_manager.dart';
import 'package:socialmediaapp/utils/colors.dart';
import 'package:socialmediaapp/widgets/app_buttons.dart';
import 'package:uuid/uuid.dart';

class CallScreen extends StatefulWidget {
  CallScreen(this.userId, this.username, this.deviceToken, {Key? key})
      : super(key: key);
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
  static const token =
      "0064b609511d6724c2292ebc74a26a22b87IAB+AME+NK6O7eFn+N4SjApw1tZjGYye4SOMcudhmvWe2+3d+UgAAAAAEACQKMvtyRjQYgEAAQDIGNBi";
  String channel = "prateekm26";

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
  /// by the remote user.
  bool callAccepted = false;

  /// if callTime can be increment.
  bool canIncrement = true;

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

  Future<void> initRtcEngine() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //final String channelName = const Uuid().v4();

    /// Create RTC client instance
    //app id
    _engine = await RtcEngine.create("4b609511d6724c2292ebc74a26a22b87");

    /// Define event handler
    _engine?.setEventHandler(
        RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) async {
        debugPrint('joinChannelSuccess $channel $uid');
        if (mounted) {
          setState(() {
            joined = true;  //first part joined
          });
        }
        ///create call on firebase
        callReference = await CallManager.instance
            .createCall("prateekm26", token, widget.userId, widget.deviceToken);
        print("Call reference-------${callReference!.id}");
        switchEffect();

        ///listen existing call on firebase
        callListener = await FirebaseFirestore.instance
            .collection("calls")
            .doc(callReference!.id)
            .snapshots()
            .listen(((DocumentSnapshot documentSnapshot) { if (documentSnapshot.exists) {
          print('Document exists on the database');
          //print("call data------${jsonEncode(documentSnapshot.data())}");
          if(CallReceiveModel.fromJson(jsonDecode(jsonEncode(documentSnapshot.data()))).call!.isEmpty){
            _engine?.destroy();
            Navigator.of(context).pop();
          }
          //profileData.notifyListeners();
        }}));
      },
      leaveChannel: (stats) {
        debugPrint("leaveChannel ${stats.toJson()}");
        if (mounted) {
          setState(() {
            joined = false; //first party leave
          });
        }
      },
      userJoined: (int uid, int elapsed) {
        debugPrint('userJoined $uid');
        setState(() {
          remoteUid = uid.toString(); //remote user joined
        });
        switchEffect();
        setState(() {
          if (!canIncrement) canIncrement = true;
          callAccepted = true;
        });
        startTimer();
      },
      userOffline: (int uid, UserOfflineReason reason) { //remote user leave
        debugPrint('userOffline $uid');
        setState(() {
          remoteUid = null;
          canIncrement = false;
        });
        switchEffect();
      },
    ));
    _engine?.enableAudio();
    _engine?.setChannelProfile(ChannelProfile.Communication);
    _engine?.setClientRole(ClientRole.Broadcaster);
    _engine?.setEnableSpeakerphone(enableSpeakerphone);
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
          padding:
              const EdgeInsets.only(top: 50.0, bottom: 80, left: 20, right: 20),
          child: Column(children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.mainColor),
              child: Center(
                  child: Text(
                widget.username.toUpperCase()[0],
                style: AppStyles.whiteBold32,
              )),
            ),
            SizedBox(height: 15,),
            Text(
              widget.username,
              style: AppStyles.blackBold32,
            ),
            const SizedBox(
              height: 10,
            ),
             Text(callAccepted?intToTimeLeft(callTime).toString():"Calling..."),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap:(){
                  switchSpeakerphone();
                },
                    child: CircularButton(Icons.volume_up_sharp,enableSpeakerphone?AppColors.mainColor:AppColors.inactiveBtnColor)),
                 InkWell(
                    onTap: () {
                      _engine?.destroy();
                      CallManager.instance.deleteCalls(widget.userId);
                      Navigator.pop(context);
                    },
                    child: CircularButton(Icons.call_end,AppColors.danger)//const RoundedButton()
                ),
                InkWell(
                    onTap:(){
                      switchMicrophone();
                    },
                    child: CircularButton(Icons.mic_off,openMicrophone?AppColors.inactiveBtnColor:AppColors.mainColor)),
              ],
            ),
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

    String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
    m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
    s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }
}
