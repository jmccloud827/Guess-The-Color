import SwiftUI

struct ColorPicker: View {
    @Environment(\.colorScheme) private var colorScheme

    @Binding var color: Color

    @AppStorage("Picker Type") var pickerType = PickerType.hue

    var body: some View {
        VStack(spacing: 15) {
            colorPreview
                .padding(.horizontal)
                .containerRelativeFrame(.vertical) { height, _ in
                    height * 0.2
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
                .tag(PickerType.hue)

            Text("Spectrum")
                .tag(PickerType.spectrum)
        }
        .pickerStyle(.segmented)
    }

    private var currentPicker: some View {
        ZStack {
            if pickerType == .hue {
                HueColorPicker(color: $color)
                    .transition(.move(edge: .leading))
                    .padding(.horizontal)
            }

            if pickerType == .spectrum {
                SpectrumColorPicker(color: $color)
                    .transition(.move(edge: .trailing))
                    .padding(.horizontal)
            }
        }
        .animation(.default, value: pickerType)
    }
}

enum PickerType: Int {
    case hue = 1
    case spectrum = 2
}

#Preview {
    @Previewable @State var color = Color.teal
    
    ColorPicker(color: $color)
}
