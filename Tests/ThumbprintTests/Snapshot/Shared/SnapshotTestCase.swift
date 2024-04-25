import Foundation
import SnapKit
import SnapshotTesting
@testable import Thumbprint
import ThumbprintTokens
import XCTest

open class SnapshotTestCase: XCTestCase {
    public enum WindowSize {
        case `default`
        case iPhoneSE
        case iPhone8
        case iPhone8Plus
        case iPadPro9_7
        case intrinsic
        case defaultWidthIntrinsicHeight
        case size(width: CGFloat, height: CGFloat, scaleHeightForContentSizeCategory: Bool = false)

        public static var allPhones: [WindowSize] { [.iPhoneSE, .iPhone8, .iPhone8Plus] }
        public static var all: [WindowSize] { .allPhones + [.iPadPro9_7] }

        public var cgSize: CGSize {
            switch self {
            case .default:
                return WindowSize.iPhone8.cgSize
            case .iPhoneSE:
                return CGSize(width: 320, height: 568)
            case .iPhone8:
                return CGSize(width: 375, height: 667)
            case .iPhone8Plus:
                return CGSize(width: 414, height: 736)
            case .iPadPro9_7:
                return CGSize(width: 1536, height: 2048)
            case .intrinsic:
                return CGSize(width: .intrinsic, height: .intrinsic)
            case .defaultWidthIntrinsicHeight:
                return CGSize(width: .defaultWidth, height: .intrinsic)
            case let .size(width, height, _):
                return CGSize(width: width, height: height)
            }
        }

        public func cgSize(compatibleWith traitCollection: UITraitCollection) -> CGSize {
            switch self {
            case let .size(width, height, true):
                return CGSize(
                    width: width,
                    height: Font.scaledValue(height, for: .text1, compatibleWith: traitCollection)
                )
            default:
                return cgSize
            }
        }
    }

    public var recordMode: Bool {
        get {
            SnapshotTesting.isRecording
        }
        set {
            SnapshotTesting.isRecording = newValue
        }
    }

    private var behavior: TestCaseBehavior!

    open override class func setUp() {
        super.setUp()

        verifyExpectedSnapshotTestDevice()

        UIView.setAnimationsEnabled(false)

        // Hide carets.
        UITextView.appearance().tintColor = .clear

        TestCaseBehavior.setUp()
    }

    open override func setUp() {
        super.setUp()

        behavior = TestCaseBehavior()
    }

    open override func tearDown() {
        recordMode = false

        let localBehavior = behavior
        behavior = nil
        localBehavior?.tearDown(
            testCase: self,
            ensureCleanProperties: true
        )

        super.tearDown()
    }

    static func verifyExpectedSnapshotTestDevice() {
        let expectedDeviceName = "iPhone 15"
        let expectedSystemVersion = "17.4"

        assert(UIDevice.current.name == expectedDeviceName, "Snapshot tests should be run on \(expectedDeviceName).")
        assert(UIDevice.current.systemVersion == expectedSystemVersion, "Snapshot tests should be run on iOS \(expectedSystemVersion).")
    }

    public func verify<T: UIView>(viewFactory: () -> T,
                                  identifier: String? = nil,
                                  useNavigationController: Bool = false,
                                  sizes: [WindowSize] = [.intrinsic],
                                  padding: CGFloat = Space.two,
                                  safeArea: UIEdgeInsets = .zero,
                                  contentSizeCategories: [UIContentSizeCategory] = .all,
                                  userInterfaceStyles: Set<UIUserInterfaceStyle> = [.light],
                                  verifyLayoutAmbiguity: Bool = true,
                                  file: StaticString = #filePath,
                                  line: UInt = #line,
                                  setUp: ((T) -> Void)? = nil) {
        var newPadding = padding

        verifyPrivate(
            viewControllerFactory: {
                let viewController = UIViewController()
                viewController.view.backgroundColor = Color.primaryBackground
                let view = viewFactory()

                if view is UITableView || view is UICollectionView {
                    // Remove padding for table/collection views as they're typically used full screen and may also contain padding.
                    newPadding = 0

                    if containsIntrinsicSize(in: sizes) {
                        XCTFail("Intrinsic size cannot be used with instances of UI(Table,Collection)View, suggest using 'sizes: .all' instead.", file: file, line: line)
                        return viewController
                    }
                }

                viewController.view.addSubview(view)

                view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }

                return viewController
            },
            identifier: identifier,
            useNavigationController: useNavigationController,
            sizes: sizes,
            padding: newPadding,
            safeArea: safeArea,
            contentSizeCategories: contentSizeCategories,
            userInterfaceStyles: userInterfaceStyles,
            verifyLayoutAmbiguity: verifyLayoutAmbiguity,
            file: file,
            line: line,
            setUp: { setUp?($0.view.subviews[0] as! T) }
        )
    }

    public func verify(view: UIView,
                       identifier: String? = nil,
                       useNavigationController: Bool = false,
                       sizes: [WindowSize] = [.intrinsic],
                       padding: CGFloat = Space.two,
                       safeArea: UIEdgeInsets = .zero,
                       contentSizeCategories: [UIContentSizeCategory] = .all,
                       userInterfaceStyles: Set<UIUserInterfaceStyle> = [.light],
                       verifyLayoutAmbiguity: Bool = true,
                       file: StaticString = #filePath,
                       line: UInt = #line,
                       setUp: (() -> Void)? = nil) {
        var newPadding = padding

        if view is UITableView || view is UICollectionView {
            // Remove padding for table/collection views as they're typically used full screen and may also contain padding.
            newPadding = 0

            if containsIntrinsicSize(in: sizes) {
                XCTFail("Intrinsic size cannot be used with instances of UI(Table,Collection)View, suggest using 'sizes: .all' instead.", file: file, line: line)
                return
            }
        }

        verifyPrivate(
            viewControllerFactory: {
                let viewController = UIViewController()
                viewController.view.backgroundColor = Color.primaryBackground
                viewController.view.addSubview(view)

                view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }

                return viewController
            },
            identifier: identifier,
            useNavigationController: useNavigationController,
            sizes: sizes,
            padding: newPadding,
            safeArea: safeArea,
            contentSizeCategories: contentSizeCategories,
            userInterfaceStyles: userInterfaceStyles,
            verifyLayoutAmbiguity: verifyLayoutAmbiguity,
            file: file,
            line: line,
            setUp: { _ in setUp?() }
        )
    }

    public func verify<T: UIViewController>(viewControllerFactory: () -> T,
                                            identifier: String? = nil,
                                            useNavigationController: Bool = false,
                                            sizes: [WindowSize] = .allPhones,
                                            safeArea: UIEdgeInsets = .zero,
                                            contentSizeCategories: [UIContentSizeCategory] = .all,
                                            userInterfaceStyles: Set<UIUserInterfaceStyle> = [.light],
                                            verifyLayoutAmbiguity: Bool = true,
                                            file: StaticString = #filePath,
                                            line: UInt = #line,
                                            setUp: ((T) -> Void)? = nil) {
        if containsIntrinsicSize(in: sizes) {
            XCTFail("Intrinsic size is not supported for view controller snapshots.", file: file, line: line)
            return
        }

        verifyPrivate(viewControllerFactory: viewControllerFactory,
                      identifier: identifier,
                      useNavigationController: useNavigationController,
                      sizes: sizes,
                      padding: 0, // Padding is not appropriate for controllers.
                      safeArea: safeArea,
                      contentSizeCategories: contentSizeCategories,
                      userInterfaceStyles: userInterfaceStyles,
                      verifyLayoutAmbiguity: verifyLayoutAmbiguity,
                      file: file,
                      line: line,
                      setUp: setUp)
    }

    public func verify(modalViewControllerFactory: @escaping () -> UIViewController,
                       identifier: String? = nil,
                       sizes: [WindowSize] = .allPhones,
                       safeArea: UIEdgeInsets = .zero,
                       contentSizeCategories: [UIContentSizeCategory] = .all,
                       userInterfaceStyles: Set<UIUserInterfaceStyle> = [.light],
                       verifyLayoutAmbiguity: Bool = true,
                       file: StaticString = #filePath,
                       line: UInt = #line,
                       setUp: (() -> Void)? = nil) {
        if containsIntrinsicSize(in: sizes) {
            XCTFail("Intrinsic size is not supported for view controller snapshots.", file: file, line: line)
            return
        }

        verify(
            viewControllerFactory: { UIViewController() },
            identifier: identifier,
            sizes: sizes,
            safeArea: safeArea,
            contentSizeCategories: contentSizeCategories,
            userInterfaceStyles: userInterfaceStyles,
            verifyLayoutAmbiguity: verifyLayoutAmbiguity,
            file: file,
            line: line,
            setUp: { presentingViewController in
                setUp?()

                var presented = false
                presentingViewController.present(modalViewControllerFactory(), animated: false) { presented = true }
                tt_waitUntil({ presented })
            }
        )
    }

    /**
     This is a specialized verify for vertical scroll view content forms that will resizes the height of the snapshot to show all the content.
     As such it doesn't take any size arguments, instead producing snapshots for all phone widths with their heights calculated per the contents.
     The tests also remove any safe areas from the enclosing window that is captured in the snapshot as they are not meant to reflect a users's screen.
     - Parameter scrollView: The scroll view whose contents we want to snapshot. Contents must be fully configured at the time of calling and
     able to layout properly for varying snapshot widths.
     - Parameter identifier: An optional identifier to apply to the snapshot files recorded.
     - Parameter verticalPadding: For content that fills up all the way to the bottom edge, additional vertical padding may be applied as to add a
     bottom margin and have the snapshot be easier to parse visually. Defaults to 0.0.
     - Parameter contentSizeCategories: Content size categories to snapshot (aka font size adjustments). Defaults to all the ones we usually
     test (XS, L/standard, XXL).
     - Parameter userInterfaceStyles: Whether to take snapshots of light and/or dark mode. Defaults to light only.
     - Parameter verifyLayoutAmbiguity: Whether to run the layout ambiguity verifier. Some custom layouts will trigger it no matter what and
     some older logic may be impractical to fix in which cases turning it off is recommended.
     */
    public func verify(
        scrollView: UIScrollView,
        identifier: String? = nil,
        verticalPadding: CGFloat = 0.0,
        contentSizeCategories: [UIContentSizeCategory] = .all,
        userInterfaceStyles: Set<UIUserInterfaceStyle> = [.light],
        verifyLayoutAmbiguity: Bool = true,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        class NoSafeAreaView: UIView {
            override var safeAreaInsets: UIEdgeInsets {
                return .zero
            }
        }

        for size in WindowSize.allPhones {
            for contentSizeCategory in contentSizeCategories {
                scrollView.frame = .init(origin: .zero, size: size.cgSize)
                scrollView.layoutIfNeeded() //  This will layout all the contents of the table so we know how big it is.
                //  Build the custom identifier since we're only sending one at a time.
                var fullIdentifier: String = {
                    if let identifier = identifier {
                        return "\(identifier)_"
                    } else {
                        return ""
                    }
                }()
                fullIdentifier.append("w\(Int(size.cgSize.width))")
                if contentSizeCategory != .unspecified {
                    fullIdentifier.append("_\(contentSizeCategory.rawValue)")
                }

                // Send it to the black box of snapshotting.
                verifyPrivate(
                    viewControllerFactory: {
                        let viewController = UIViewController()
                        viewController.view = NoSafeAreaView()
                        viewController.view.addSubview(scrollView)
                        scrollView.snp.makeConstraints { make in
                            make.edges.equalToSuperview()
                        }
                        return viewController
                    },
                    identifier: fullIdentifier,
                    useNavigationController: false,
                    sizes: [.size(width: size.cgSize.width, height: scrollView.contentSize.height + verticalPadding)],
                    padding: 0.0,
                    safeArea: .zero,
                    contentSizeCategories: [contentSizeCategory],
                    userInterfaceStyles: userInterfaceStyles,
                    verifyLayoutAmbiguity: verifyLayoutAmbiguity,
                    file: file,
                    line: line,
                    setUp: nil
                )
            }
        }
    }

    // MARK: - Private

    private func verifyPrivate<T: UIViewController>(viewControllerFactory: () -> T, // swiftlint:disable:this function_parameter_count
                                                    identifier: String?,
                                                    useNavigationController: Bool,
                                                    sizes: [WindowSize],
                                                    padding: CGFloat,
                                                    safeArea: UIEdgeInsets,
                                                    contentSizeCategories: [UIContentSizeCategory],
                                                    userInterfaceStyles: Set<UIUserInterfaceStyle>,
                                                    verifyLayoutAmbiguity: Bool,
                                                    file: StaticString,
                                                    line: UInt,
                                                    setUp: ((T) -> Void)?) {
        sizes.forEach { size in
            contentSizeCategories.forEach { contentSizeCategory in
                userInterfaceStyles.forEach { userInterfaceStyle in
                    // Since iOS 13.2 some views do not respond to content size category changes, so we're also manually
                    // overriding it here.
                    // TODO: (ileitch) Check if this is necessary is future versions.
                    let contentSizeCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
                    let userInterfaceStyleCollection = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
                    var collection = UITraitCollection(traitsFrom: [contentSizeCollection, userInterfaceStyleCollection])
                    if size.cgSize.width >= 768 {
                        collection = UITraitCollection(traitsFrom: [
                            collection,
                            UITraitCollection(horizontalSizeClass: .regular),
                        ])
                    }
                    if size.cgSize.height >= 1024 {
                        collection = UITraitCollection(traitsFrom: [
                            collection,
                            UITraitCollection(verticalSizeClass: .regular),
                        ])
                    }
                    Font.traitCollectionOverrideForTesting = collection

                    var identifierParts: [String] = []

                    if let identifier = identifier {
                        identifierParts.append(identifier)
                    }

                    let cgSize = size.cgSize(compatibleWith: collection)
                    if sizes.count > 1 {
                        let width = cgSize.width == .intrinsic ? "Intrinsic" : String(Int(cgSize.width))
                        let height = cgSize.height == .intrinsic ? "Intrinsic" : String(Int(cgSize.height))
                        identifierParts.append("\(width)x\(height)")
                    }

                    if contentSizeCategory != .unspecified {
                        identifierParts.append(contentSizeCategory.rawValue)
                    }

                    if userInterfaceStyle == .dark {
                        identifierParts.append("Dark")
                    }

                    var fullIdentifier: String?

                    if !identifierParts.isEmpty {
                        fullIdentifier = identifierParts.joined(separator: "_")
                    }

                    let config = ViewImageConfig(safeArea: safeArea, size: cgSize, traits: collection)

                    let viewController = viewControllerFactory()
                    let snapshotViewController: UIViewController

                    if useNavigationController {
                        snapshotViewController = UINavigationController(rootViewController: viewController)
                    } else {
                        snapshotViewController = viewController
                    }

                    assertSnapshot(
                        matching: snapshotViewController,
                        as: .viewController(
                            on: config,
                            padding: padding,
                            precision: 0.999, // Allow for up to 0.001% difference.
                            verifyLayoutAmbiguity: verifyLayoutAmbiguity,
                            file: file,
                            line: line,
                            setUp: { setUp?(viewController) }
                        ),
                        named: fullIdentifier,
                        file: file,
                        testName: self.testName,
                        line: line
                    )

                    Font.traitCollectionOverrideForTesting = nil
                }
            }
        }
    }

    private func containsIntrinsicSize(in sizes: [WindowSize]) -> Bool {
        sizes.contains { $0.cgSize.width == .intrinsic || $0.cgSize.height == .intrinsic }
    }

    private var testName: String {
        let normalizedName = name.replacingOccurrences(of: "[]", with: "")
        return String(normalizedName.split(separator: " ").last ?? "")
    }
}

public extension Array where Element == SnapshotTestCase.WindowSize {
    static var allPhones: [Element] { Element.allPhones }
    static var all: [Element] { Element.all }

    static func allPhonesWithFixedHeight(_ height: CGFloat, scaleForContentSizeCategory: Bool = false) -> [Element] {
        Element.allPhones.map {
            .size(width: $0.cgSize.width, height: height, scaleHeightForContentSizeCategory: scaleForContentSizeCategory)
        }
    }

    static func allWithFixedHeight(_ height: CGFloat, scaleForContentSizeCategory: Bool = false) -> [Element] {
        Element.all.map {
            .size(width: $0.cgSize.width, height: height, scaleHeightForContentSizeCategory: scaleForContentSizeCategory)
        }
    }

    static var allWithIntrinsicHeight: [Element] {
        Element.allPhones.map {
            .size(width: $0.cgSize.width, height: .intrinsic)
        }
    }
}

public extension Array where Element == UIContentSizeCategory {
    static var all: [Element] { [.extraSmall, .large, .accessibilityExtraLarge] }
}

public extension Set where Element == UIUserInterfaceStyle {
    static var all: Set<UIUserInterfaceStyle> { [.light, .dark] }
}

public extension Snapshotting where Value: UIViewController, Format == UIImage {
    static func viewController(
        on config: ViewImageConfig,
        padding: CGFloat,
        precision: Float,
        verifyLayoutAmbiguity: Bool,
        file: StaticString,
        line: UInt,
        setUp: (() -> Void)? = nil
    ) -> Snapshotting {
        SimplySnapshotting.image(precision: precision).asyncPullback { viewController in
            Async<UIImage> { callback in
                var size = config.size ?? .zero
                let hasIntrinsicWidth = size.width == .intrinsic
                let hasIntrinsicHeight = size.height == .intrinsic

                // Pick an arbitrary width and height that should fit all content.
                // Even though we're not going to create a snapshot with this szie, it must be larger
                // than the content to avoid clipping.
                if hasIntrinsicHeight {
                    size.height = 10000
                }

                if hasIntrinsicWidth {
                    size.width = 10000
                }

                // We use a middle child view controller to override the trait collection at the superview of
                // whatever we're testing so the background is right for the UI style.
                let containerViewController = UIViewController()
                let containerView = containerViewController.view!
                containerView.backgroundColor = Color.primaryBackground
                containerViewController.addChild(viewController)
                containerView.addSubview(viewController.view)
                viewController.view.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(padding)
                }

                viewController.didMove(toParent: containerViewController)

                let rootViewController = UIViewController()
                rootViewController.preferredContentSize = size
                rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

                rootViewController.addChild(containerViewController)
                rootViewController.setOverrideTraitCollection(config.traits, forChild: containerViewController)
                rootViewController.view.addSubview(containerView)

                // Now that we've set the container in place we add different constraints depending on the test
                // configuration
                if hasIntrinsicWidth {
                    containerView.snp.makeConstraints { make in
                        make.leading.equalToSuperview()
                    }

                    containerView.setContentHuggingPriority(.required, for: .horizontal)
                    containerView.setContentCompressionResistancePriority(.required, for: .horizontal)
                } else {
                    containerView.snp.makeConstraints { make in
                        make.leading.trailing.equalToSuperview()
                    }
                }

                if hasIntrinsicHeight {
                    containerView.snp.makeConstraints { make in
                        make.top.equalToSuperview()
                    }

                    containerView.setContentHuggingPriority(.required, for: .vertical)
                    containerView.setContentCompressionResistancePriority(.required, for: .vertical)
                } else {
                    containerView.snp.makeConstraints { make in
                        make.top.bottom.equalToSuperview()
                    }
                }

                containerViewController.didMove(toParent: rootViewController)

                //  Put it all in a window and force a layout.
                let window = Window(safeArea: config.safeArea, size: size)
                rootViewController.view.frame = window.frame
                window.rootViewController = rootViewController
                window.makeKeyAndVisible()
                rootViewController.view.setNeedsLayout()
                rootViewController.view.layoutIfNeeded()

                DispatchQueue.main.async {
                    setUp?()

                    if verifyLayoutAmbiguity, case let .ambiguous(ambiguousView) = viewController.view.verifySubtreeLayoutAmbiguity() {
                        XCTFail("Layout ambiguity found in view \(ambiguousView)", file: file, line: line)
                    }

                    DispatchQueue.main.async {
                        let bounds = hasIntrinsicWidth || hasIntrinsicHeight
                            ? CGRect(origin: window.bounds.origin, size: containerView.frame.size)
                            : window.bounds
                        let image = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: config.traits)).image { ctx in
                            window.layer.render(in: ctx.cgContext)
                        }

                        callback(image)
                    }
                }
            }
        }
    }
}

private class Window: UIWindow {
    private let safeArea: UIEdgeInsets?

    init(safeArea: UIEdgeInsets?, size: CGSize) {
        self.safeArea = safeArea
        super.init(frame: .init(origin: .zero, size: size))
        backgroundColor = Color.gray
        diffTool = "ksdiff"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var safeAreaInsets: UIEdgeInsets {
        if let safeArea = safeArea {
            return safeArea
        }

        return super.safeAreaInsets
    }
}

public extension CGFloat {
    static var intrinsic: CGFloat = -1
    static var defaultWidth: CGFloat = SnapshotTestCase.WindowSize.default.cgSize.width
}
