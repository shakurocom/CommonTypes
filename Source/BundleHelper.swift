//
//
//

import UIKit

public struct BundleHelper {

    private static var bundle: Bundle = Bundle.main

    // MARK: - Public

    /// Searches for and creates a bundle for the specified class and bundle name.
    /// - parameter targetClass: the class name in the bundle it is in.
    /// - parameter bundleName: bundle name with resources.
    public static func setup(targetClass: AnyClass, bundleName: String) {
        let bundle = Bundle(for: targetClass)
        if let bundleURL = bundle.url(forResource: bundleName, withExtension: "bundle"),
           let bundleInternal = Bundle(url: bundleURL) {
            self.bundle = bundleInternal
        } else {
            self.bundle = bundle
        }
    }

    /// Instantiate of the image with the given name from the bundle.
    /// - parameter named: image name.
    public static func image(named: String, compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage? {
        return UIImage(named: named, in: bundle, compatibleWith: traitCollection)
    }

    /// Instantiate of the color with the given name from the bundle.
    /// - parameter named: color name.
    public static func color(named: String, compatibleWith traitCollection: UITraitCollection? = nil) -> UIColor? {
        return UIColor(named: named, in: bundle, compatibleWith: traitCollection)
    }

    /// Registers the specified font from the bundle.
    /// - parameter name: font name.
    /// - parameter extension: font extension.
    public static func registerFont(name: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: name, withExtension: fontExtension) else {
            debugPrint("Couldn't find font \(name)")
            return
        }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            debugPrint("Couldn't load data from the font \(name)")
            return
        }
        guard let font = CGFont(fontDataProvider) else {
            debugPrint("Couldn't create font(\(name)) from data")
            return
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            debugPrint("Error registering font(\(name)): maybe it was already registered.")
            return
        }
    }

    /// Registers the specified fonts from the bundle.
    public static func registerFonts(_ fonts: [(fontName: String, fontExtension: String)]) {
        for font in fonts {
            registerFont(name: font.fontName, fontExtension: font.fontExtension)
        }
    }

    /// Returns instance of a UINib.
    /// - parameter nibName: UINib file name.
    public static func loadNib(name: String) -> UINib {
        return UINib(nibName: name, bundle: bundle)
    }

    /**
     Returns instance of a UIViewController.

     - Parameters:
        - targetClass: view controller type.
        - nibName: view controller nib name.

     - Example:
     `let exampleViewController: ExampleViewController = BundleHelper.instantiateViewControllerFromBundle(targetClass: ExampleViewController.type, nibName: "kExampleViewController"`
     */
    public static func instantiateViewController<T>(targetClass: T.Type, nibName: String) -> T where T: UIViewController {
        return targetClass.init(nibName: nibName, bundle: bundle)
    }

    // MARK: - Private

    private init() {}

}
