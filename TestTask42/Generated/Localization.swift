// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum Localization {

  internal enum Alert {
    /// Alarm went off
    internal static let title = Localization.tr("Localizable", "alert.title")
  }

  internal enum Buttons {
    /// Cancel
    internal static let cancel = Localization.tr("Localizable", "buttons.cancel")
    /// Ok
    internal static let ok = Localization.tr("Localizable", "buttons.ok")
    /// Pause
    internal static let pause = Localization.tr("Localizable", "buttons.pause")
    /// Play
    internal static let play = Localization.tr("Localizable", "buttons.play")
    /// Continue recording
    internal static let record = Localization.tr("Localizable", "buttons.record")
    /// Stop
    internal static let stop = Localization.tr("Localizable", "buttons.stop")
  }

  internal enum Error {
    /// Failed to open a media file
    internal static let failedToOpenFile = Localization.tr("Localizable", "error.failed_to_open_file")
  }

  internal enum Home {
    /// Alarm
    internal static let alarm = Localization.tr("Localizable", "home.alarm")
    /// Sleep Timer
    internal static let sleepTimer = Localization.tr("Localizable", "home.sleep_timer")
    /// 
    internal static let title = Localization.tr("Localizable", "home.title")
  }

  internal enum SleepTime {
    /// min
    internal static let min = Localization.tr("Localizable", "sleep_time.min")
    /// off
    internal static let off = Localization.tr("Localizable", "sleep_time.off")
  }

  internal enum State {
    /// 
    internal static let idle = Localization.tr("Localizable", "state.idle")
    /// Paused
    internal static let paused = Localization.tr("Localizable", "state.paused")
    /// Playing
    internal static let playing = Localization.tr("Localizable", "state.playing")
    /// Recording
    internal static let recording = Localization.tr("Localizable", "state.recording")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
