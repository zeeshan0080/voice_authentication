import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../../app_providers/authentication_provider.dart';

class GeneralPopup extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;
  final bool canPop;
  const GeneralPopup({super.key, required this.title, required this.description, required this.buttonText, required this.onTap, this.canPop=true});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Center(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
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
                            onPressed: ()=> onTap(),
                            child: Text(
                              buttonText,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthenticationPopup extends StatefulWidget {
  final Function onSuccess;
  const AuthenticationPopup({super.key, required this.onSuccess});

  @override
  State<AuthenticationPopup> createState() => _AuthenticationPopupState();
}

class _AuthenticationPopupState extends State<AuthenticationPopup> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authState, child) {
        return Material(
          color: Colors.transparent,
          child: PopScope(
            canPop: false,
            child: Center(
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Voice Authentication',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Authenticate your voice to continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  authState.recordVoiceNote(
                                    onSuccess: widget.onSuccess
                                  );
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: authState.recordState == RecordState.record ? Colors.red : Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(200)
                                  ),
                                  child: Center(
                                    child: Icon(Icons.mic, size: 40, color: authState.recordState == RecordState.record ? Colors.red : Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              authState.recordState == RecordState.record ?
                              Text(
                                '00:0${authState.recordedDuration}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w400
                                ),
                              ) : const Text(
                                'Tap to start',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w400
                                ),
                              )
                            ],
                          ),
                          if(authState.recordState != RecordState.record)
                            ...[
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      ///logout user
                                      await authState.logout();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Login again',
                                      style: TextStyle(
                                          color: Colors.red
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

