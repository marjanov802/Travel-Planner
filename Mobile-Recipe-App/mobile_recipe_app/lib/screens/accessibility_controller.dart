import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AccessibilityController {
  static final AccessibilityController _instance =
      AccessibilityController._internal();
  factory AccessibilityController() => _instance;
  AccessibilityController._internal();

  bool _captionsEnabled = false;
  bool _voiceOverEnabled = false;
  String _currentCaption = "";
  OverlayEntry? _captionOverlay;
  FlutterTts flutterTts = FlutterTts();

  bool get captionsEnabled => _captionsEnabled;
  bool get voiceOverEnabled => _voiceOverEnabled;

  Future<void> initTTS() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void setCaptionsEnabled(bool value, BuildContext context) {
    _captionsEnabled = value;
    if (value) {
      _showCaptionOverlay(context);
    } else {
      _removeCaptionOverlay();
    }
  }

  void setVoiceOverEnabled(bool value) {
    _voiceOverEnabled = value;
    if (!value) {
      flutterTts.stop();
    }
  }

  void updateCaption(String caption, BuildContext context) {
    _currentCaption = caption;
    if (_captionsEnabled && _captionOverlay != null) {
      _removeCaptionOverlay();
      _showCaptionOverlay(context);
    }
  }

  void speak(String text) {
    if (_voiceOverEnabled) {
      flutterTts.speak(text);
    }
  }

  void _showCaptionOverlay(BuildContext context) {
    _removeCaptionOverlay();

    _captionOverlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 150,
        left: 20,
        right: 20,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              _currentCaption,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_captionOverlay!);
  }

  void _removeCaptionOverlay() {
    _captionOverlay?.remove();
    _captionOverlay = null;
  }
}
