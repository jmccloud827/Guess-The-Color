import SwiftUI

struct SpectrumColorPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var color: Color
    
    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
    @State private var isChangingColor = false
    
    init(color: Binding<Color>) {
        _color = color
        let (hue, saturation, brightness) = color.wrappedValue.getHSB()
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }
    
    var body: some View {
        picker
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
                if isChangingColor {
                    return
                }
            
                let (hue, saturation, brightness) = color.getHSB()
                self.hue = hue
                self.saturation = saturation
                self.brightness = brightness
            }
    }
    
    private var picker: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(gradient: hueGradient, startPoint: .top, endPoint: .bottom)
                    )
                    .blur(radius: 5)
                    .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: .init(hue: 0, saturation: 0, brightness: 1), location: 0.0),
                            .init(color: .clear, location: 0.5),
                            .init(color: .init(hue: 0, saturation: 0, brightness: 0), location: 1.0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing)
                            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    )
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: colorScheme == .light ? .black : .white, radius: 1)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                isChangingColor = true
                                
                                withAnimation(.linear(duration: 0.1)) {
                                    self.hue = min(max(gesture.location.y / geometry.size.height, 0), 1)
                                    
                                    let xPercentage = gesture.location.x / geometry.size.width
                                    if xPercentage < 0.5 {
                                        self.saturation = min(max(xPercentage * 2, 0), 1)
                                        self.brightness = 1
                                    } else {
                                        self.saturation = 1
                                        self.brightness = 1 - min(max((xPercentage - 0.5) * 2, 0), 1)
                                    }
                                }
                            }
                            .onEnded { _ in
                                isChangingColor = false
                            }
                    )
                
                Circle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .scaleEffect(isChangingColor ? 1.75 : 1)
                    .animation(.linear(duration: 0.25), value: isChangingColor)
                    .position(x: getPickerXPercentage() * geometry.size.width,
                              y: hue * geometry.size.height)
            }
        }
    }
    
    private func getPickerXPercentage() -> Double {
        if saturation != 1 {
            return saturation / 2
        } else {
            return (1 - brightness) / 2 + 0.5
        }
    }
}

#Preview {
    @Previewable @State var color = Color.teal
    
    SpectrumColorPicker(color: $color)
        .padding()
}
