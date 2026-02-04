import SwiftUI

struct ColorPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var color: Color
    
    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
    @State private var isChangingHue = false
    @State private var isChangingSaturationAndBrightness = false
    
    init(color: Binding<Color>) {
        _color = color
        let (hue, saturation, brightness) = color.wrappedValue.getHSB()
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }
    
    var body: some View {
        GeometryReader { outerGeometry in
            VStack(spacing: 20) {
                saturationAndHuePicker
                    .frame(height: outerGeometry.size.height * 0.75)
                
                hueSlider
            }
        }
        .onChange(of: hue) {
            self.color = Color(hue: hue, saturation: saturation, brightness: brightness)
        }
        .onChange(of: saturation) {
            self.color = Color(hue: hue, saturation: saturation, brightness: brightness)
        }
        .onChange(of: brightness) {
            self.color = Color(hue: hue, saturation: saturation, brightness: brightness)
        }
        .onChange(of: color) {
            if isChangingHue || isChangingSaturationAndBrightness {
                return
            }
            
            let (hue, saturation, brightness) = color.getHSB()
            self.hue = hue
            self.saturation = saturation
            self.brightness = brightness
        }
    }
    
    private var saturationAndHuePicker: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [
                            Color(hue: hue, saturation: 0, brightness: 1),
                            Color(hue: hue, saturation: 1, brightness: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing)
                    )
                    .overlay(
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: Color.white, location: 0.0),
                            .init(color: Color(white: 0.6, opacity: 0.5), location: 0.4),
                            .init(color: Color(white: 0.05), location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom)
                            .blendMode(.multiply)
                            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    )
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: colorScheme == .light ? .black : .white, radius: 1)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                isChangingSaturationAndBrightness = true
                                
                                withAnimation(.linear(duration: 0.1)) {
                                    self.saturation = min(max(gesture.location.x / geometry.size.width, 0), 1)
                                    self.brightness = 1 - min(max(gesture.location.y / geometry.size.height, 0), 1)
                                }
                            }
                            .onEnded { _ in
                                isChangingSaturationAndBrightness = false
                            }
                    )
                
                Circle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .scaleEffect(isChangingSaturationAndBrightness ? 1.75 : 1)
                    .animation(.linear(duration: 0.25), value: isChangingSaturationAndBrightness)
                    .position(x: saturation * geometry.size.width,
                              y: (1 - brightness) * geometry.size.height)
            }
        }
    }
    
    private var hueSlider: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(LinearGradient(gradient: hueGradient, startPoint: .leading, endPoint: .trailing))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            isChangingHue = true
                            
                            if gesture.location.x < 0 || gesture.location.x > geometry.size.width {
                                return
                            }
                            
                            withAnimation(.linear(duration: 0.1)) {
                                hue = gesture.location.x / geometry.size.width
                            }
                        }
                        .onEnded { _ in
                            isChangingHue = false
                        }
                )
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: colorScheme == .light ? .black : .white, radius: 1)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(style: .init(lineWidth: 3))
                        .frame(width: 10)
                        .position(x: hue * geometry.size.width, y: geometry.size.height / 2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
        }
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
