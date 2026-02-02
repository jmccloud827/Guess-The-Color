import SwiftUI

struct ColorPicker3: View {
    @Binding var color: Color
    
    var body: some View {
        VStack {
            color
                .frame(height: 100)
            
            GeometryReader { geometry in
                Rectangle()
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: self.makeSatBrightColors()), startPoint: .leading, endPoint: .trailing))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                if gesture.location.x < 0 || gesture.location.x > geometry.size.width {
                                    return
                                }
                                
                                if gesture.location.y < 0 || gesture.location.y > geometry.size.height {
                                    return
                                }
                                
                                let hsb = getHSB()
                                let test = gesture.location.x / geometry.size.width
                                let test2 = gesture.location.y / geometry.size.height
                                color = Color(hue: hsb.hue, saturation: test, brightness: 1-test)
                            }
                    )
            }
            .frame(height: 200)
            
            GeometryReader { geometry in
                Rectangle()
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: self.makeHueColors(stepSize: 0.01)), startPoint: .leading, endPoint: .trailing))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                if gesture.location.x < 0 || gesture.location.x > geometry.size.width {
                                    return
                                }
                                
                                let hsb = getHSB()
                                color = Color(hue: gesture.location.x / geometry.size.width, saturation: 1, brightness: 1)
                            }
                    )
                    .overlay {
                        let hsb = getHSB()
                        Rectangle()
                            .frame(width: 10)
                            .position(x: hsb.hue * geometry.size.width, y: geometry.size.height / 2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
            }
            .frame(height: 100)
        }
    }
    
    func getHSB() -> (hue: Double, saturation: Double, brightness: Double) {
        let uiColor = UIColor(color)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (hue, saturation, brightness)
    }
    
    func makeSatBrightColors() -> [Color] {
        let hsb = getHSB()
        return stride(from: 0, to: 0.5, by: 0.005).map { _ in
            Color(hue: hsb.hue, saturation: 1, brightness: 1)
        } + stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: hsb.hue, saturation: 1-$0, brightness: 1-$0)
        }
    }
    
    func makeHueColors(stepSize: Double) -> [Color] {
        stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: 1)
        }
    }
}

#Preview {
    @Previewable @State var color = Color.teal
    
    ColorPicker3(color: $color)
        .padding()
}
