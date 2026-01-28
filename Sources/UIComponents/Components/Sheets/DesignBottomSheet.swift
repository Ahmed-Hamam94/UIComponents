//
//  DesignBottomSheet.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    private let content: Content
    private let theme: BottomSheetThemeProtocol
    
    @State private var offset: CGFloat = 0
    
    public init(
        isPresented: Binding<Bool>,
        theme: BottomSheetThemeProtocol = DesignBottomSheetTheme(),
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.theme = theme
        self.content = content()
    }
    
    public var body: some View {
        if isPresented {
            ZStack(alignment: .bottom) {
                // Background Overlay
                theme.overlayColor
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                // Sheet Content
                VStack(spacing: 0) {
                    // Pull Handle
                    Capsule()
                        .fill(theme.handleColor)
                        .frame(width: 40, height: 5)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    
                    content
                        .padding([.horizontal, .bottom], theme.padding)
                }
                .frame(maxWidth: .infinity)
                .background(theme.backgroundColor)
                .cornerRadius(theme.cornerRadius, corners: [.topLeft, .topRight])
                .offset(y: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                offset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 100 {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                            withAnimation {
                                offset = 0
                            }
                        }
                )
                .transition(.move(edge: .bottom))
            }
            .ignoresSafeArea(edges: .bottom)
            .zIndex(100)
        }
    }
}

// Extension for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public extension View {
    func designBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        theme: BottomSheetThemeProtocol = DesignBottomSheetTheme(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            DesignBottomSheet(isPresented: isPresented, theme: theme, content: content)
        }
    }
}

struct DesignBottomSheet_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        Color.gray.opacity(0.1)
            .designBottomSheet(isPresented: $isPresented) {
                VStack(spacing: 20) {
                    Text("Bottom Sheet Title")
                        .font(.headline)
                    Text("This is a custom draggable bottom sheet. You can put any SwiftUI content here.")
                        .multilineTextAlignment(.center)
                    
                    DesignButton(title: "Done", style: PrimaryTheme(), action: { isPresented = false })
                }
            }
    }
}
