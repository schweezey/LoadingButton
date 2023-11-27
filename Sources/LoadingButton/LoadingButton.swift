import SwiftUI

public struct LoadingButton<Content: View>: View {
    @Binding var isLoading: Bool

    var style: LoadingButtonStyle
    let content: Content
    var action: () -> () = {}
    
    public init(action: @escaping () -> Void, isLoading: Binding<Bool>, style: LoadingButtonStyle? = nil, @ViewBuilder builder: () -> Content) {
        self._isLoading = isLoading
        self.style = style ?? LoadingButtonStyle()
        content = builder()
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            if !isLoading {
                isLoading = true
                action()
            }
        }) {
            ZStack {
                Rectangle()
                    .fill(isLoading ? style.loadingBackgroundColor : style.backgroundColor)
                    .frame(width: isLoading ? style.height : style.width, height: style.height)
                    .cornerRadius(isLoading ? style.height/2 : style.cornerRadius)

                if isLoading {
                    CircleLoadingBar(style: style)
                }
                else {
                    VStack { content }
                }
            }
        }
        .frame(width: style.width, height: style.height)
        .disabled(isLoading)
        .animation(.easeInOut, value: isLoading)
    }
}
