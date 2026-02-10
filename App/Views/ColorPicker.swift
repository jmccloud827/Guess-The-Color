import SwiftUI

struct ColorPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var color: Color
    
    @AppStorage("Picker Type") var pickerType = 1
    
    var body: some View {
        VStack(spacing: 15) {
            colorPreview
                .containerRelativeFrame(.vertical) { length, _ in
                    length * 0.2
                }
                
            typePicker
                
            currentPicker
        }
    }
    
    private var colorPreview: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(color)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
            .addShadow()
    }
    
    private var typePicker: some View {
        Picker("", selection: $pickerType) {
            Text("Hue")
                .tag(1)
            
            Text("Spectrum")
                .tag(2)
        }
        .pickerStyle(.segmented)
    }
    
    private var currentPicker: some View {
        ZStack {
            HueColorPicker(color: $color)
                .offset(x: pickerType == 1 ? 0 : -screenSize.width)
            
            SpectrumColorPicker(color: $color)
                .offset(x: pickerType == 2 ? 0 : screenSize.width)
        }
        .animation(.default, value: pickerType)
    }
}

#Preview {
    @Previewable @State var color = Color.teal
    
    ColorPicker(color: $color)
        .padding()
}
