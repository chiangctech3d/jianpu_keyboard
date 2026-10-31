import 'package:flutter/services.dart';

/// Canal com o código Swift em `macos/Runner/AppDelegate.swift`.
const macosChannel = MethodChannel('jianpu_keyboard/native');

Future<void> requestAccessibility() =>
    macosChannel.invokeMethod<bool>('requestAccessibility');

Future<void> openAccessibilitySettings() =>
    macosChannel.invokeMethod<void>('openAccessibilitySettings');
