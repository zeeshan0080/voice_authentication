import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../app_providers/authentication_provider.dart';
import '../dependency_inject.dart';
import 'home_view.dart';
import 'widgets/popups.dart';

class VoiceEnrollView extends StatefulWidget {
  const VoiceEnrollView({super.key});

  @override
  State<VoiceEnrollView> createState() => _VoiceEnrollViewState();
}

class _VoiceEnrollViewState extends State<VoiceEnrollView> {
  final _authProvider = sl<AuthenticationProvider>();

  _onRecord(){
    _authProvider.recordVoiceNote(
      enroll: true,
      onSuccess: ()=> _onSuccess()
    );
  }

  _onSuccess() async {
    await showGeneralDialog(
    context: context,
    barrierLabel: 'success notice',
    barrierDismissible: false,
    pageBuilder: (_, __, ___){
      return GeneralPopup(
        title: 'Successfully Enrolled',
        description: 'Your voice for authentication is completed',
        buttonText: 'Continue',
        canPop: false,
        onTap: (){
          _authProvider.login();
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => route.isCurrent);
        },
      );
    }
    );
  }

  _onFailure() async {
    await showGeneralDialog(
        context: context,
        barrierLabel: 'failure notice',
        barrierDismissible: false,
        pageBuilder: (_, __, ___){
          return GeneralPopup(
            title: 'Enroll Failed',
            description: 'Please try again to complete the authentication process',
            buttonText: 'Try again',
            canPop: false,
            onTap: (){
              Navigator.of(context).pop();
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authState, child) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                "Voice Enrollment",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  authState.recordState == RecordState.record ?
                  _renderRecording(seconds: authState.recordedDuration) :
                  _renderStart()
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  _renderStart(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Record a 5 seconds voice note in your normal tone\nTap on record to start",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              //color: Theme.of(context).primaryColor
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2),
                      borderRadius: BorderRadius.circular(5)),
                ),
                onPressed: (){
                  _onRecord();
                },
                child: const Text(
                  'Record',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  _renderRecording({required int seconds}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(200)
              ),
              child: const Center(
                child: Icon(Icons.mic, size: 40, color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "00:0$seconds",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
