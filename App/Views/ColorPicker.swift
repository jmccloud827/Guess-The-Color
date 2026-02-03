import SwiftUI

struct ColorPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var color: Color
    
    @State private var hsb: (hue: Double, saturation: Double, brightness: Double)
    
    init(color: Binding<Color>) {
        _color = color
        self.hsb = Self.getHSB(for: color.wrappedValue)
    }
    
    var body: some View {
        GeometryReader { outerGeometry in
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(color)
                    .shadow(color: colorScheme == .light ? .black : .white, radius: 1)
                    .frame(height: outerGeometry.size.height * 0.7)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                
                makeSlider(gradient: saturationAndBrightnessGradient,
                           xPositionRatio: getSatBrightPosition()) { _, widthPercentage in
                    let newColor =
                        if widthPercentage < 0.5 {
                            Color(hue: hsb.hue, saturation: widthPercentage * 2, brightness: 1)
                        } else {
                            Color(hue: hsb.hue, saturation: 1, brightness: 1 - (widthPercentage - 0.5) * 2)
                        }
                            
                    let newHSB = Self.getHSB(for: newColor)
                    if abs(self.hsb.hue - newHSB.hue) > 0.01 {
                        return self.color
                    }
                            
                    return newColor
                }
                
                makeSlider(gradient: hueGradient,
                           xPositionRatio: hsb.hue) { _, widthPercentage in
                    Color(hue: widthPercentage, saturation: hsb.saturation, brightness: hsb.brightness)
                }
            }
        }
        .onChange(of: color) {
            hsb = Self.getHSB(for: color)
        }
    }
    
    private func makeSlider(gradient: Gradient, xPositionRatio: Double, onDragChange: @escaping (DragGesture.Value, Double) -> Color) -> some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing))
                .shadow(color: colorScheme == .light ? .black : .white, radius: 1)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            let widthPercentage = gesture.location.x / geometry.size.width
                            if widthPercentage < 0 || widthPercentage >= 1 {
                                return
                            }
                            
                            let newColor = onDragChange(gesture, widthPercentage)
                            
                            withAnimation(.linear(duration: 0.1)) {
                                self.color = newColor
                                self.hsb = Self.getHSB(for: newColor)
                            }
                        }
                )
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(style: .init(lineWidth: 3))
                        .frame(width: 10)
                        .position(x: xPositionRatio * geometry.size.width, y: geometry.size.height / 2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
        }
    }
    
    private var saturationAndBrightnessGradient: Gradient {
        return Gradient(colors: stride(from: 0, to: 0.5, by: 0.01).map {
            Color(hue: hsb.hue, saturation: $0, brightness: 1)
        } + stride(from: 0.5, to: 1, by: 0.01).map {
            Color(hue: hsb.hue, saturation: $0, brightness: 1)
        } + stride(from: 0, to: 0.5, by: 0.01).map {
            Color(hue: hsb.hue, saturation: 1, brightness: 1 - $0)
        } + stride(from: 0.5, to: 1, by: 0.01).map {
            Color(hue: hsb.hue, saturation: 1, brightness: 1 - $0)
        })
    }
    
    private func getSatBrightPosition() -> Double {
        if hsb.saturation == 1 {
            return 0.5 + (1 - hsb.brightness) / 2
        } else {
            return hsb.saturation / 2
        }
    }
    
    private static func getHSB(for color: Color) -> (hue: Double, saturation: Double, brightness: Double) {
        let uiColor = UIColor(color)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (hue, saturation, brightness)
    }
}

var hueGradient: Gradient {
    Gradient(colors: stride(from: 0, to: 1, by: 0.01).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    })
}

#Preview {
    @Previewable @State var color = Color.teal
    
    ColorPicker(color: $color)
        .padding()
}
