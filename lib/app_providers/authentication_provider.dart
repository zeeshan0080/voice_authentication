import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_authentication/constants/app_constants.dart';

enum Status { initial, loading, loaded, error }

class AuthenticationProvider with ChangeNotifier {
  final SharedPreferences sf;

  AuthenticationProvider({required this.sf});

  ///recording
  late StreamSubscription<RecordState> _recordSub;
  RecordState recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? amplitude;

  late AudioRecorder _recorder;
  int _voiceNoteSize = 5;
  int recordedDuration = 5;

  late Timer _timer;
  String? voiceNotePath;

  startService(){
    _recorder = AudioRecorder();
    _recordSub = _recorder.onStateChanged().listen((state){
      recordState = state;
      notifyListeners();
      print("record state: ${recordState.name}");
    });
    _amplitudeSub = _recorder.onAmplitudeChanged((const Duration(milliseconds: 200))).listen((amp){
      amplitude = amp;
      notifyListeners();
      print("amplitude: ${amplitude?.current} - ${amplitude?.max}");
    });
    print("Recording service started");
  }

  bool get isLoggedIn {
    return sf.getBool(AppKeys.user) == null ? false : true;
  }

  Future<void> login() async {
    await sf.setBool(AppKeys.user, true);
  }

  Future<void> logout() async {
    await sf.clear();
  }

  recordVoiceNote({required Function onSuccess, bool enroll=false}) async {
    try{
      if(await _recorder.hasPermission()){
        final isSupported = await _recorder.isEncoderSupported(AudioEncoder.wav);
        print('Encoder ${AudioEncoder.wav.name} supported: $isSupported');
        if(isSupported){
          const config = RecordConfig(encoder: AudioEncoder.wav);
          final dir = await getApplicationDocumentsDirectory();
          recordedDuration = _voiceNoteSize;
          await _recorder.start(
            config,
            path: '${dir.path}/auth1.wav'
          );
          _timer = Timer.periodic(const Duration(seconds: 1), (timer){
            if(timer.tick == 5){
              _timer.cancel();
              if(enroll){
                _stopAndSaveRecording(onSuccess: onSuccess);
              }else{
               _stopAndValidateRecording(onSuccess: onSuccess);
              }
            }
            recordedDuration = _voiceNoteSize - timer.tick;
            notifyListeners();
            print('seconds: $recordedDuration');
          });
        }
      }else{
        print('Mic permission denied');
      }
    } catch(e){
      print('recordVoiceNote: $e');
    }
  }

  _stopAndSaveRecording({required Function onSuccess}) async {
    voiceNotePath = await _recorder.stop();
    notifyListeners();
    print("Voice note path: $voiceNotePath");
    ///convert and store voice embeddings
    onSuccess();
  }

  _stopAndValidateRecording({required Function onSuccess}) async {
    voiceNotePath = await _recorder.stop();
    notifyListeners();
    print("Voice note path: $voiceNotePath");
    ///validate with stored auth data
    onSuccess();

  }


}