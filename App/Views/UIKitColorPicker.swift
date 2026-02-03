import SwiftUI

struct UIKitColorPicker: UIViewControllerRepresentable {
    private let delegate: ColorPickerDelegate
    private let pickerTitle: String
    private let selectedColor: UIColor

    init(title: String, selectedColor: Color, didSelectColor: @escaping ((Color) -> Void)) {
        self.pickerTitle = title
        self.selectedColor = UIColor(selectedColor)
        self.delegate = ColorPickerDelegate(didSelectColor)
    }
 
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let colorPickerController = UIColorPickerViewController()
        colorPickerController.delegate = delegate
        colorPickerController.title = ""
        colorPickerController.selectedColor = selectedColor
        colorPickerController.supportsAlpha = false
        colorPickerController.supportsEyedropper = false
        return colorPickerController
    }

 
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {}
    
    private class ColorPickerDelegate: NSObject, UIColorPickerViewControllerDelegate {
        var didSelectColor: ((Color) -> Void)

        init(_ didSelectColor: @escaping ((Color) -> Void)) {
            self.didSelectColor = didSelectColor
        }
        
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            let selectedUIColor = viewController.selectedColor
            didSelectColor(Color(uiColor: selectedUIColor))
        }

        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            print("dismiss colorPicker")
        }

    }
}

#Preview {
    UIKitColorPicker(title: "Test", selectedColor: .black) { _ in

    }
}
