import SwiftUI

struct ColorPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var color: Color
    
    @AppStorage("Picker Type") var pickerType = 1
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(color)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                    .addShadow()
                    .frame(height: geometry.size.height * 0.25)
                
                Picker("", selection: $pickerType) {
                    Text("Hue")
                        .tag(1)
                    
                    Text("Spectrum")
                        .tag(2)
                }
                .pickerStyle(.segmented)
                
                ZStack {
                    HueColorPicker(color: $color)
                        .offset(x: pickerType == 1 ? 0 : -UIScreen.main.bounds.width)
                    
                    SpectrumColorPicker(color: $color)
                        .offset(x: pickerType == 2 ? 0 : UIScreen.main.bounds.width)
                }
                .animation(.default, value: pickerType)
            }
        }
    }
}

#Preview {
    @Previewable @State var color = Color.teal
    
    ColorPicker(color: $color)
        .padding()
}
