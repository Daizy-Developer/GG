import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const appID = 'YOUR_APP_ID';
  RtcEngine? _agora;

  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  void initializeAgora() async {
    await Permission.microphone.request();

    _agora = await RtcEngine.create(appID);

    // Set event handlers
    _agora?.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        // Handle join success
      },
      userJoined: (int uid, int elapsed) {
        // Handle remote user joined
      },
      userOffline: (int uid, UserOfflineReason reason) {
        // Handle remote user left
      },
    ));

    await _agora?.joinChannel(null, 'channelName', null, 0);

    setState(() {});
  }

  void muteMicrophone(bool muted) {
    _agora?.muteLocalAudioStream(muted);
  }

  void endCall() async {
    await _agora?.leaveChannel();
    _agora?.destroy();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Agora Flutter Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => muteMicrophone(true),
                child: Text('Mute Microphone'),
              ),
              ElevatedButton(
                onPressed: () => endCall(),
                child: Text('End Call'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

