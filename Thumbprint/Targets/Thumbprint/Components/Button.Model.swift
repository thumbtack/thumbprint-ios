import UIKit

public extension Button {
    /**
     Specifies an image to show in the button next to the label, and where to show it.
     */
    struct Icon: Equatable {
        /**
         An enum specifying the position to show the icon at. More expressive than a boolean, and easier to add new
         cases in the future if the designers want them.
         */
        public enum Position: Equatable {
            case leading
            case trailing
        }

        /**
         The position to show the image at.
         */
        public let position: Position

        /**
         The image to show next to the laben in the button.
         */
        public let image: UIImage

        /**
         Default init.
         */
        public init(_ position: Position, image: UIImage) {
            self.position = position
            self.image = image
        }

        /**
         Convenience init. Much of the time we're using methods that may return nil in unfortunate circumstances to
         fetch the icon to show in a button. This method wraps the repetitive unwrapping of optionality to make the
         setup logic more readable.

         For some reason it has to be used with the explicit type, instead of the shorthand `.init(...)` syntax or
         the Swift compiler will reject it 🤷🏽‍♂️
         - Parameter position: The position to show the icon at.
         - Parameter icon: The image to display, or nil if it can't be found.
         */
        public init?(_ position: Position, image: UIImage?) {
            guard let iconImage = image else {
                return nil
            }

            self.init(position, image: iconImage)
        }
    }
}
