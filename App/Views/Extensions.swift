import SwiftUI

extension View {
    func makeTopInset() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .clipped()
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .addShadow(opacity: 0.25)
            .padding(.bottom)
            .padding(.horizontal)
    }
    
    func makeBottomInsetButton(_ action: @escaping () -> Void) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.bar)
            }
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
            .addShadow(opacity: 0.25)
            .padding(.top)
            .padding(.horizontal)
            .onTapGesture {
                action()
            }
    }
    
    func addShadow(opacity: Double = 1) -> some View {
        ShadowWrapper(opacity: opacity) {
            self
        }
    }
}

extension FormatStyle where Self == Decimal.FormatStyle.Currency {
    static var roundedPercent: FloatingPointFormatStyle<Double>.Percent {
        .init()
            .precision(.significantDigits(3))
            .rounded(rule: .up)
    }
}

private struct ShadowWrapper<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    let opacity: Double
    let content: () -> Content
    
    var body: some View {
        content()
            .shadow(color: colorScheme == .light ? .black.opacity(opacity) : .white.opacity(opacity), radius: 1)
    }
}

extension Color {
    func makeLabel(title: String, isSmall: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: isSmall ? 20 : 40)
            .foregroundStyle(self)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: isSmall ? 20 : 40))
            .addShadow()
            .overlay {
                Text(title)
                    .font(isSmall ? .body : .title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(isSmall ? 5 : 10)
                    .frame(maxWidth: .infinity)
                    .glassEffect(.regular.interactive())
                    .padding(isSmall ? 10 : 15)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
    }
    
    func getRGB() -> (red: Double, green: Double, blue: Double) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue)
    }
    
    func getHSB() -> (hue: Double, saturation: Double, brightness: Double) {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (hue, saturation, brightness)
    }
}

extension Gradient {
    static let hue =
        Gradient(colors: stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: 1)
        })
}

extension Game {
    func makeScoreToActualColorSection(title: String, you: Double, me: Double) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .padding(.top, 5)
                .padding(.vertical, 5)
            
            VStack(alignment: .leading, spacing: 0) {
                you.makeGaugeLabel(title: "You: ")
                
                me.makeGaugeLabel(title: "Me: ")
            }
            .padding(.horizontal)
        }
    }
}

extension Double {
    func makeGaugeLabel(title: String) -> some View {
        HStack {
            HStack {
                Text(title)
                
                Text(self.formatted(.roundedPercent))
                    .bold()
                    .contentTransition(.numericText())
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .containerRelativeFrame(.horizontal) { length, _ in
                length * (1 / 4)
            }
            
            Gauge(value: self) {
                Text("")
            }
            .gaugeStyle(.accessoryLinear)
        }
    }
}

#Preview("Regular") {
    let game = Game(difficulty: .hard, isPlusMode: false)
    
    return GameView(game: game)
}

#Preview("Plus Mode") {
    let game = Game(difficulty: .hard, isPlusMode: true)
    
    return GameView(game: game)
}
