import ApplicationServices
import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

class KeyboardPanel: NSPanel {
  override var canBecomeMain: Bool { false }
}

/// Canal `jianpu_keyboard/native`: digitação, tamanho da janela e permissão.
enum JianpuChannel {
  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "jianpu_keyboard/native", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "type":
        result(type(call.arguments as? String ?? ""))
      case "requestAccessibility":
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        result(AXIsProcessTrustedWithOptions(options))
      case "setContentSize":
        if let size = call.arguments as? [String: NSNumber],
           let width = size["width"]?.doubleValue,
           let height = size["height"]?.doubleValue,
           let panel = MainFlutterWindow.panel {
          // Mantém a borda direita e o topo: o teclado numérico abre à esquerda.
          let old = panel.frame
          var frame = panel.frameRect(forContentRect: NSRect(x: 0, y: 0, width: width, height: height))
          frame.origin.x = old.maxX - frame.width
          frame.origin.y = old.maxY - frame.height
          panel.setFrame(frame, display: true)
        }
        result(nil)
      case "openAccessibilitySettings":
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
          NSWorkspace.shared.open(url)
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  /// Envia [text] ao app em primeiro plano, sem modificadores.
  private static func type(_ text: String) -> Bool {
    guard AXIsProcessTrusted(), !text.isEmpty else { return false }
    let units = Array(text.utf16)
    for keyDown in [true, false] {
      guard let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: keyDown) else {
        return false
      }
      event.flags = []
      event.keyboardSetUnicodeString(stringLength: units.count, unicodeString: units)
      event.post(tap: .cghidEventTap)
    }
    return true
  }
}
