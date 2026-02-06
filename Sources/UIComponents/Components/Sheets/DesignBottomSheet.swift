//
//  DesignBottomSheet.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

public struct DesignBottomSheet<Content: View, T: BottomSheetThemeProtocol>: View {
    @Binding var isPresented: Bool
    private let content: Content
    private let theme: T
    
    @State private var offset: CGFloat = 0
    
    public init(
        isPresented: Binding<Bool>,
        theme: T,
        @ViewBuilder content: @escaping () -> Content
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
                SheetContent(
                    content: content,
                    theme: theme,
                    offset: offset,
                    onDragChanged: { height in
                        if height > 0 {
                            offset = height
                        }
                    },
                    onDragEnded: { height in
                        if height > 100 {
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
            .accessibilityElement(children: .contain)
            .accessibilityAddTraits(.isModal)
            .accessibilityLabel("Bottom sheet")
        }
    }
}

//extension DesignBottomSheet where T == DesignBottomSheetTheme {
//    public init(
//        isPresented: Binding<Bool>,
//        theme: DesignBottomSheetTheme = .default,
//        @ViewBuilder content: @escaping () -> Content
//    ) {
//        self._isPresented = isPresented
//        self.theme = theme
//        self.content = content()
//    }
//}

// MARK: - Sheet Content View
private struct SheetContent<Content: View, T: BottomSheetThemeProtocol>: View {
    let content: Content
    let theme: T
    let offset: CGFloat
    let onDragChanged: (CGFloat) -> Void
    let onDragEnded: (CGFloat) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Pull Handle
            SheetHandle(color: theme.handleColor)
            
            content
                .padding([.horizontal, .bottom], theme.padding)
        }
        .frame(maxWidth: .infinity)
        .background(theme.backgroundColor)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: theme.cornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: theme.cornerRadius
            )
        )
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    onDragChanged(value.translation.height)
                }
                .onEnded { value in
                    onDragEnded(value.translation.height)
                }
        )
    }
}

// MARK: - Sheet Handle View
private struct SheetHandle: View {
    let color: Color
    
    var body: some View {
        Capsule()
            .fill(color)
            .frame(width: 40, height: 5)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .accessibilityLabel("Drag handle")
            .accessibilityHint("Swipe down to dismiss")
    }
}

// MARK: - Bottom Sheet View Modifier
private struct BottomSheetModifier<SheetContent: View, T: BottomSheetThemeProtocol>: ViewModifier {
    @Binding var isPresented: Bool
    let theme: T
    @ViewBuilder let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            DesignBottomSheet(isPresented: $isPresented, theme: theme, content: sheetContent)
        }
    }
}

public extension View {
    func designBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        theme: DesignBottomSheetTheme = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheetModifier(
            isPresented: isPresented,
            theme: theme,
            sheetContent: content
        ))
    }
    
    func designBottomSheet<Content: View, T: BottomSheetThemeProtocol>(
        isPresented: Binding<Bool>,
        theme: T,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheetModifier(
            isPresented: isPresented,
            theme: theme,
            sheetContent: content
        ))
    }
}

#Preview("Bottom Sheet") {
    Color.gray.opacity(0.1)
        .designBottomSheet(isPresented: .constant(true)) {
            VStack(spacing: 20) {
                Text("Bottom Sheet Title")
                    .font(.headline)
                Text("This is a custom draggable bottom sheet. You can put any SwiftUI content here.")
                    .multilineTextAlignment(.center)
                
                DesignButton(title: "Done", style: .primary, action: {})
                    .padding(.horizontal)
            }
        }
}
