import SwiftUI

class ColorPickerDelegate: NSObject, UIColorPickerViewControllerDelegate {
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

struct ColorPickerView: UIViewControllerRepresentable {
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
}

#Preview {
    @Previewable @State var color = RGB(r: 0, g: 128 / 255, b: 128 / 255)
    
    VStack {
        Color(red: color.r, green: color.g, blue: color.b)
        Text("r: \(Int(color.r * 255)), g: \(Int(color.g * 255)), b: \(Int(color.b * 255))")
        
        NewColourWheel(radius: 400, rgbColour: $color)
    }
    
//    ColorSampler(color: color)
    
//    ColorPickerView(title: "Test", selectedColor: .black) { _ in
//
//    }
}

struct NewColourWheel: View {
    
    /// Draws at a specified radius.
    var radius: CGFloat
    
    /// The RGB colour. Is a binding as it can change and the view will update when it does.
    @Binding var rgbColour: RGB
    
    var body: some View {
        
        /// Geometry reader so we can know more about the geometry around and within the view.
        GeometryReader { geometry in
            ZStack {
                
                /// The colour wheel. See the definition.
                AngularGradientHueView(radius: self.radius)
                    /// Smoothing out of the colours.
                    .blur(radius: 10)
                    /// The outline.
                    .overlay(
                        Circle()
                            .size(CGSize(width: self.radius, height: self.radius))
                            .stroke(Color("Outline"), lineWidth: 10)
                            /// Inner shadow.
                            .shadow(color: Color("ShadowInner"), radius: 8)
                    )
                    /// Clip inner shadow.
                    .clipShape(
                        Circle()
                            .size(CGSize(width: self.radius, height: self.radius))
                    )
                    /// Outer shadow.
                    .shadow(color: Color("ShadowOuter"), radius: 15)
                
                /// This *is* required for the saturation scale of the wheel. It actually makes the gradient less "accurate" but looks nicer. It's basically just a white radial gradient that blends the colours together nicer.
                RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .center, startRadius: 0, endRadius: self.radius/2 - 10)
                    .blendMode(.screen)

                /// The little knob that shows selected colour.
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: (self.radius/2 - 10) * self.rgbColour.hsv.s)
                    .rotationEffect(.degrees(-Double(self.rgbColour.hsv.h)))
                
            }
            /// The gesture so we can detect taps and drags on the wheel.
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        
                        /// Work out angle which will be the hue.
                        let y = geometry.frame(in: .global).midY - value.location.y
                        let x = value.location.x - geometry.frame(in: .global).midX
                        
                        /// Use `atan2` to get the angle from the center point then convert than into a 360 value with custom function(find it in helpers).
                        let hue = atan2To360(atan2(y, x))
                        
                        /// Work out distance from the center point which will be the saturation.
                        let center = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
                        
                        /// Maximum value of sat is 1 so we find the smallest of 1 and the distance.
                        let saturation = min(distance(center, value.location)/(self.radius/2), 1)
                        
                        /// Convert HSV to RGB and set the colour which will notify the views.
                        self.rgbColour = HSV(h: hue, s: saturation, v: 1).rgb
                    }
            )
        }
        /// Set the size.
        .frame(width: self.radius, height: self.radius)
    }
}

func atan2To360(_ angle: CGFloat) -> CGFloat {
    var result = angle
    if result < 0 {
        result = (2 * CGFloat.pi) + angle
    }
    return result * 180 / CGFloat.pi
}

func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let xDist = a.x - b.x
    let yDist = a.y - b.y
    return CGFloat(sqrt(xDist * xDist + yDist * yDist))
}

struct HSV {
    var h: CGFloat // Angle in degrees [0,360] or -1 as Undefined
    var s: CGFloat // Percent [0,1]
    var v: CGFloat // Percent [0,1]
    
    static func toRGB(h: CGFloat, s: CGFloat, v: CGFloat) -> RGB {
        if s == 0 { return RGB(r: v, g: v, b: v) } // Achromatic grey
        
        let angle = (h >= 360 ? 0 : h)
        let sector = angle / 60 // Sector
        let i = floor(sector)
        let f = sector - i // Factorial part of h
        
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))
        
        switch(i) {
        case 0:
            return RGB(r: v, g: t, b: p)
        case 1:
            return RGB(r: q, g: v, b: p)
        case 2:
            return RGB(r: p, g: v, b: t)
        case 3:
            return RGB(r: p, g: q, b: v)
        case 4:
            return RGB(r: t, g: p, b: v)
        default:
            return RGB(r: v, g: p, b: q)
        }
    }
    
    var rgb: RGB {
        return HSV.toRGB(h: self.h, s: self.s, v: self.v)
    }
    
}

struct RGB {

    var r: CGFloat // Percent [0,1]
    var g: CGFloat // Percent [0,1]
    var b: CGFloat // Percent [0,1]
    
    static func toHSV(r: CGFloat, g: CGFloat, b: CGFloat) -> HSV {
        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)
        
        let v = max
        let delta = max - min
        
        guard delta > 0.00001 else { return HSV(h: 0, s: 0, v: max) }
        guard max > 0 else { return HSV(h: -1, s: 0, v: v) } // Undefined, achromatic grey
        let s = delta / max
        
        let hue: (CGFloat, CGFloat) -> CGFloat = { max, delta -> CGFloat in
            if r == max { return (g-b)/delta } // between yellow & magenta
            else if g == max { return 2 + (b-r)/delta } // between cyan & yellow
            else { return 4 + (r-g)/delta } // between magenta & cyan
        }
        
        let h = hue(max, delta) * 60 // In degrees
        
        return HSV(h: (h < 0 ? h+360 : h) , s: s, v: v)
    }
    
    var hsv: HSV {
        return RGB.toHSV(r: self.r, g: self.g, b: self.b)
    }
}

struct AngularGradientHueView: View {
    
    var colours: [Color] = {
        let hue = Array(0...359).reversed()
        return hue.map {
            Color(UIColor(hue: CGFloat($0) / 359, saturation: 1, brightness: 1, alpha: 1))
        }
    }()
    var radius: CGFloat
    
    var body: some View {
        AngularGradient(gradient: Gradient(colors: colours), center: UnitPoint(x: 0.5, y: 0.5))
            .frame(width: radius, height: radius)
            .clipShape(Circle())
    }
}
