import SwiftUI

struct ColorPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var color: Color
    
    @AppStorage("Picker Type") var pickerType = 1
    
    var body: some View {
        VStack(spacing: 15) {
            colorPreview
                .padding(.horizontal)
                .containerRelativeFrame(.vertical) { length, _ in
                    length * 0.2
                }
                
            typePicker
                .padding(.horizontal)
                
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
            if pickerType == 1 {
                HueColorPicker(color: $color)
                    .transition(.move(edge: .leading))
                    .padding(.horizontal)
            }
            
            if pickerType == 2 {
                SpectrumColorPicker(color: $color)
                    .transition(.move(edge: .trailing))
                    .padding(.horizontal)
            }
        }
        .animation(.default, value: pickerType)
    }
}

#Preview {
    @Previewable @State var color = Color.teal
    
    ColorPicker(color: $color)
}
