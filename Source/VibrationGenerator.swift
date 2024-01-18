//
// Copyright (c) 2020 Shakuro (https://shakuro.com/)
// Sergey Laschuk
//

import AudioToolbox
import Foundation
import UIKit

// TODO: add example
/// Instanceble because new styles require preparation (done in init) to be able to play without delay.
public class VibrationGenerator {

    /// Preferrable. Supported on iPhone 7 and above AND iOS 10+
    public enum NewStyle {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        case selection
    }

    /// Supported everywhere.
    public enum OldStyle {
        /// default type of vibration
        case defaultVibration

        /// weak boom
        case peek

        /// strong boom
        case pop

        /// series of three weak booms
        case nope
    }

    private let newStyleGenerator: GeneratorWrapper?
    private let oldStyle: OldStyle?

    // MARK: - Initialization

    /// - parameter newStyle: style of vibration on newer devices. Preferable to use this.
    /// - parameter oldStyle: style of vibration on older devices. Used if `newStyle` is not provided or not supported.
    public init(newStyle: NewStyle?, oldStyle: OldStyle?) {
        self.oldStyle = oldStyle
        if let realNewStyle = newStyle, VibrationGenerator.isNewStyleSupported() {
            newStyleGenerator = GeneratorWrapper(style: realNewStyle)
        } else {
            newStyleGenerator = nil
        }
    }

    // MARK: - Public

    public func prepare() {
        newStyleGenerator?.prepare()
    }

    public func vibrate() {
        if let generator = newStyleGenerator {
            generator.vibrate()
        } else if let realOldStyle = oldStyle {
            switch realOldStyle {
            case .defaultVibration:
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            case .peek:
                AudioServicesPlaySystemSound(1519) // Actuate "Peek" feedback (weak boom)
            case .pop:
                AudioServicesPlaySystemSound(1520) // Actuate "Pop" feedback (strong boom)
            case .nope:
                AudioServicesPlaySystemSound(1521) // Actuate "Nope" feedback (series of three weak booms)
            }
        }
    }

    // MARK: - Private

    private static func isNewStyleSupported() -> Bool {
        // NOTE: currently there is no proper way (without private APIs) to solve this:
        //      https://stackoverflow.com/questions/41444274/how-to-check-if-haptic-engine-uifeedbackgenerator-is-supported
        switch DeviceType.current {
        case .iPhone2G,
                .iPhone3G, .iPhone3GS,
                .iPhone4G, .iPhone4GCDMA, .iPhone4GRevA, .iPhone4S,
                .iPhone5GSM, .iPhone5Global, .iPhone5CGSM, .iPhone5CGlobal, .iPhone5SGSM, .iPhone5SGlobal,
                .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus,
                .iPhoneSE1G,
                .iPod1G, .iPod2G, .iPod3G, .iPod4G, .iPod5G, .iPod6G,
                .iPad1G, .iPad1G3G, .iPad2G, .iPad2GGSM, .iPad2GCDMA, .iPad2GRev,
                .iPad3G, .iPad3GCDMA, .iPad3GGSM,
                .iPad4G, .iPad4GGSM, .iPad4GCDMA,
                .iPadMini1G, .iPadMini1GGSM, .iPadMini1GCDMA,
                .iPadMini2G, .iPadMini2GCellular, .iPadMini2GCellularChina,
                .iPadMini3G, .iPadMini3GCellular, .iPadMini3GCellularChina,
                .iPadMini4G, .iPadMini4GCellular,
                .iPadAir1G, .iPadAir1GCellular, .iPadAir1GCellularChina,
                .iPadAir2G, .iPadAir2GCellular,
                .iPadPro1G9i, .iPadPro1G9iCellular, .iPadPro1G10i, .iPadPro1G10iCellular, .iPadPro1G12i, .iPadPro1G12iCellular,
                .iPadPro1G11i, .iPadPro1G11i1TB, .iPadPro1G11iCellular, .iPadPro1G11iCellular1TB,
                .iPadPro2G11i, .iPadPro2G11iCellular, .iPadPro2G12i, .iPadPro2G12iCellular,
                .simulatorI386, .simulatorX8664, .simulatorARM64,
                .notAvailable:
            return false

        case .iPod7G,
                .iPad5G, .iPad5GCellular,
                .iPad6G, .iPad6GCellular,
                .iPad7G, .iPad7GCellular,
                .iPad8G, .iPad8GCellular,
                .iPad9G, .iPad9GCellular,
                .iPad10G, .iPad10GCellular,
                .iPadMini5G, .iPadMini5GCellular,
                .iPadMini6G, .iPadMini6GCellular,
                .iPadAir3G, .iPadAir3GCellular,
                .iPadAir4G, .iPadAir4GCellular,
                .iPadAir5G, .iPadAir5GCellular,
                .appleWatch38mm, .appleWatch42mm,
                .appleWatch1S38mm, .appleWatch1S42mm,
                .appleWatch2S38mm, .appleWatch2S42mm,
                .appleWatch3S38mm, .appleWatch3S38mmCellular, .appleWatch3S42mm, .appleWatch3S42mmCellular,
                .appleWatch4S40mm, .appleWatch4S40mmCellular, .appleWatch4S44mm, .appleWatch4S44mmCellular,
                .appleWatch5S40mm, .appleWatch5S40mmCellular, .appleWatch5S44mm, .appleWatch5S44mmCellular,
                .appleWatch6S40mm, .appleWatch6S40mmCellular, .appleWatch6S44mm, .appleWatch6S44mmCellular,
                .appleWatchSE40mm, .appleWatchSE40mmCellular, .appleWatchSE44mm, .appleWatchSE44mmCellular,
                .appleWatch7S41mm, .appleWatch7S41mmCellular, .appleWatch7S45mm, .appleWatch7S45mmCellular,
                .appleWatch8S41mm, .appleWatch8S41mmCellular, .appleWatch8S45mm, .appleWatch8S45mmCellular,
                .appleWatch9S41mm, .appleWatch9S41mmCellular, .appleWatch9S45mm, .appleWatch9S45mmCellular,
                .appleWatchSE2G40mm, .appleWatchSE2G40mmCellular, .appleWatchSE2G44mm, .appleWatchSE2G44mmCellular,
                .appleWatchUltra1G, .appleWatchUltra2G,
                .iPadPro3G11i, .iPadPro3G11iCellularUS, .iPadPro3G11iCellularChina, .iPadPro3G11iCellularGlobal,
                .iPadPro3G12i, .iPadPro3G12i1TB, .iPadPro3G12iCellular, .iPadPro3G12iCellular1TB,
                .iPadPro4G, .iPadPro4GCellular, .iPadPro4G11i, .iPadPro4G11iCellular,
                .iPadPro5G, .iPadPro5GCellularUS, .iPadPro5GCellularGlobal, .iPadPro5GCellularChina,
                .iPadPro6G, .iPadPro6GCellular:
            // should be, but untested
            return false

        case .iPhone7GSM, .iPhone7Global, .iPhone7PlusGSM, .iPhone7PlusGlobal,
                .iPhone8GSM, .iPhone8Global, .iPhone8PlusGSM, .iPhone8PlusGlobal,
                .iPhoneXGSM, .iPhoneXGlobal, .iPhoneXS, .iPhoneXSMax, .iPhoneXSMaxU, .iPhoneXR,
                .iPhone11, .iPhone11Pro, .iPhone11ProMax,
                .iPhoneSE2G, .iPhoneSE3G,
                .iPhone12Mini, .iPhone12, .iPhone12Pro, .iPhone12ProMax,
                .iPhone13Pro, .iPhone13ProMax, .iPhone13Mini, .iPhone13,
                .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax,
                .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
            return true

        case .appleTV1G, .appleTV2G, .appleTV3G2012, .appleTV3G2013, .appleTVHD, .appleTV4K1G, .appleTV4K2G,
                .iMac2009_20i, .iMac2009_21i, .iMac2009_27i, .iMac2010_21i, .iMac2010_27i, .iMac2011_21i, .iMac2011_27i,
                .iMac2012_21i, .iMac2012_27i, .iMac2013_21i, .iMac2013_27i, .iMac2014_21i_dualG, .iMac2014_21i, .iMac2014_27i,
                .iMac2015_21i, .iMac2015_21i_4K, .iMac2015_27i, .iMac2017_21i, .iMac2017_21i_4K, .iMac2017_27i, .iMac2019_27i,
                .iMac2019_21i, .iMac2020, .iMac2020_radeonPro, .iMac2021_4p, .iMac2021_2p,
                .iMacPro,
                .macBook2009_unibody, .macBook2009_early, .macBook2009_late, .macBook2010, .macBook2015, .macBook2016, .macBook2017,
                .macBookAir2009, .macBookAir2010_11i, .macBookAir2010_13i, .macBookAir2011_11i, .macBookAir2011_13i,
                .macBookAir2012_11i, .macBookAir2012_13i, .macBookAir2013_11i, .macBookAir2013_13i, .macBookAir2015_11i,
                .macBookAir2015_13i, .macBookAir2018, .macBookAir2019, .macBookAir2020,
                .macBookAirM1,
                .macBookPro2008early, .macBookPro2008late, .macBookPro2009_17i, .macBookPro2009_15i, .macBookPro2009_13i, .macBookPro2010_17i,
                .macBookPro2010_15i, .macBookPro2010_13i, .macBookPro2011_13i, .macBookPro2011_15i, .macBookPro2011_17i, .macBookPro2012_15i,
                .macBookPro2012_13i, .macBookPro2013_15i, .macBookPro2013_13i, .macBookPro2014_13i, .macBookPro2014_15i, .macBookPro2014_15i_dualG,
                .macBookPro2015_15i, .macBookPro2015_15i_dualG, .macBookPro2015_13i, .macBookPro2016_13i_2t, .macBookPro2016_13i_4t,
                .macBookPro2016_15i, .macBookPro2017_13i_2t, .macBookPro2017_13i_4t, .macBookPro2017_15i, .macBookPro2018_15i,
                .macBookPro2018_13i, .macBookPro2019_15i, .macBookPro2019_13i, .macBookPro2019_16i, .macBookPro2019_16i_radeonPro,
                .macBookPro2020_13i_4t, .macBookPro2020_13i_2t, .macBookProM1_2020, .macBookProM1_2021_16i_pro,
                .macBookProM1_2021_16i_max, .macBookProM1_2021_14i_pro, .macBookProM1_2021_14i_max,
                .macMini2009, .macMini2010, .macMini2011_i5, .macMini2011_i7, .macMini2011_server, .macMini2012, .macMini2012_1TB,
                .macMini2014, .macMini2018, .macMiniM12020,
                .macPro2009, .macPro2010, .macPro2013, .macPro2019, .homePodMini:
            return false
        }
    }

}

private class GeneratorWrapper {

    private let style: VibrationGenerator.NewStyle
    private let notificationGenerator: UINotificationFeedbackGenerator?
    private let impactGenerator: UIImpactFeedbackGenerator?
    private let selectionGenerator: UISelectionFeedbackGenerator?

    internal init(style: VibrationGenerator.NewStyle) {
        self.style = style
        switch style {
        case .error,
             .success,
             .warning:
            self.notificationGenerator = UINotificationFeedbackGenerator()
            self.impactGenerator = nil
            self.selectionGenerator = nil
        case .light:
            self.notificationGenerator = nil
            self.impactGenerator = UIImpactFeedbackGenerator(style: .light)
            self.selectionGenerator = nil
        case .medium:
            self.notificationGenerator = nil
            self.impactGenerator = UIImpactFeedbackGenerator(style: .medium)
            self.selectionGenerator = nil
        case .heavy:
            self.notificationGenerator = nil
            self.impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
            self.selectionGenerator = nil
        case .selection:
            self.notificationGenerator = nil
            self.impactGenerator = nil
            self.selectionGenerator = UISelectionFeedbackGenerator()
        }
    }

    internal func vibrate() {
        switch style {
        case .error: notificationGenerator?.notificationOccurred(.error)
        case .success: notificationGenerator?.notificationOccurred(.success)
        case .warning: notificationGenerator?.notificationOccurred(.warning)
        case .light,
             .medium,
             .heavy: impactGenerator?.impactOccurred()
        case .selection:
            selectionGenerator?.selectionChanged()
        }
    }

    internal func prepare() {
        notificationGenerator?.prepare()
        impactGenerator?.prepare()
        selectionGenerator?.prepare()
    }

}
