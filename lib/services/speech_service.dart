import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService extends ChangeNotifier {
  late SpeechToText _speechToText;
  late FlutterTts _flutterTts;

  bool _isListening = false;
  bool _isSpeaking = false;
  bool _speechEnabled = false;
  String _recognizedText = '';
  String _currentLocale = 'ko_KR';
  double _speechRate = 0.5;
  double _volume = 0.9;
  double _pitch = 1.0;

  // Getters
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get speechEnabled => _speechEnabled;
  String get recognizedText => _recognizedText;
  double get speechRate => _speechRate;
  double get volume => _volume;
  double get pitch => _pitch;

  SpeechService() {
    _initSpeech();
    _initTts();
  }

  // STT 초기화
  Future<void> _initSpeech() async {
    _speechToText = SpeechToText();

    try {
      // 마이크 권한 요청
      final permission = await Permission.microphone.request();

      if (permission.isGranted) {
        _speechEnabled = await _speechToText.initialize(
          onStatus: _onSpeechStatus,
          onError: _onSpeechError,
          debugLogging: kDebugMode,
        );
      } else {
        _speechEnabled = false;
        if (kDebugMode) {
          print('마이크 권한이 거부되었습니다.');
        }
      }
    } catch (e) {
      _speechEnabled = false;
      if (kDebugMode) {
        print('음성 인식 초기화 오류: $e');
      }
    }

    notifyListeners();
  }

  // TTS 초기화
  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    try {
      // 한국어 설정
      await _flutterTts.setLanguage(_currentLocale);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setVolume(_volume);
      await _flutterTts.setPitch(_pitch);

      // TTS 상태 리스너 설정
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        notifyListeners();
      });

      _flutterTts.setErrorHandler((message) {
        _isSpeaking = false;
        if (kDebugMode) {
          print('TTS 오류: $message');
        }
        notifyListeners();
      });

      // 사용 가능한 언어 확인
      if (kDebugMode) {
        final languages = await _flutterTts.getLanguages;
        print('사용 가능한 언어: $languages');
      }

    } catch (e) {
      if (kDebugMode) {
        print('TTS 초기화 오류: $e');
      }
    }
  }

  // 음성 인식 시작
  Future<void> startListening({Function(String)? onResult}) async {
    if (!_speechEnabled || _isListening) return;

    try {
      _recognizedText = '';
      notifyListeners();

      await _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          if (onResult != null) {
            onResult(_recognizedText);
          }
          notifyListeners();
        },
        localeId: _currentLocale,
        listenFor: Duration(minutes: 10),
        pauseFor: const Duration(seconds: 10),
        listenOptions: SpeechListenOptions(
          cancelOnError: false,
          partialResults: true,
          autoPunctuation: true,
          enableHapticFeedback: true,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('음성 인식 시작 오류: $e');
      }
    }
  }

  // 음성 인식 중지
  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
    }
  }

  // 음성 합성 (TTS)
  Future<void> speak(String text) async {
    if (text.isEmpty || _isSpeaking) return;

    try {
      // 현재 재생 중인 음성이 있으면 중지
      await _flutterTts.stop();

      // 텍스트 음성 변환
      await _flutterTts.speak(text);
    } catch (e) {
      _isSpeaking = false;
      if (kDebugMode) {
        print('TTS 재생 오류: $e');
      }
      notifyListeners();
    }
  }

  // TTS 중지
  Future<void> stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
      notifyListeners();
    }
  }

  // TTS 설정 업데이트
  Future<void> updateTtsSettings({
    double? speechRate,
    double? volume,
    double? pitch,
  }) async {
    if (speechRate != null) {
      _speechRate = speechRate;
      await _flutterTts.setSpeechRate(_speechRate);
    }

    if (volume != null) {
      _volume = volume;
      await _flutterTts.setVolume(_volume);
    }

    if (pitch != null) {
      _pitch = pitch;
      await _flutterTts.setPitch(_pitch);
    }

    notifyListeners();
  }

  // 마이크 권한 다시 요청
  Future<bool> requestMicrophonePermission() async {
    final permission = await Permission.microphone.request();

    if (permission.isGranted) {
      await _initSpeech();
      return true;
    }

    return false;
  }

  // STT 상태 변화 콜백
  void _onSpeechStatus(String status) {
    _isListening = status == 'listening';
    if (kDebugMode) {
      print('STT 상태: $status');
    }
    notifyListeners();
  }

  // STT 오류 콜백
  void _onSpeechError(dynamic error) {
    _isListening = false;
    if (kDebugMode) {
      print('STT 오류: $error');
    }
    notifyListeners();
  }

  // 음성 인식 텍스트 초기화
  void clearRecognizedText() {
    _recognizedText = '';
    notifyListeners();
  }

  // 사용 가능한 로케일 목록 가져오기
  Future<List<dynamic>> getAvailableLanguages() async {
    try {
      return await _speechToText.locales();
    } catch (e) {
      if (kDebugMode) {
        print('로케일 목록 가져오기 오류: $e');
      }
      return [];
    }
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }
}