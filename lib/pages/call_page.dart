
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}
class _CallPageState extends State<CallPage> {
  var id;

  @override
  void initState() {
    super.initState();
    _getUniqueUserId().then((value) {
      setState(() {
        id = value;
      });
    });
  }

  Future<String> _getUniqueUserId() async {
    // Example of obtaining the user ID using Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'default_user_id';
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
    } else {
      return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 871194070, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: 'e3d7ad3df3628375a6431a0a8fbac9c61bac97a3d27670c578ae7dc2e7314165', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: id,
        userName: '$id user_name',
        callID: "call_id",
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      ),
    );
    }
  }
}
