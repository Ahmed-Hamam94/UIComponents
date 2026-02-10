//
//  UIBottomSheet.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 28/01/2026.
//

import SwiftUI

extension UI {
    /// A draggable surface that slides up from the bottom of the screen.
    ///
    /// It is recommended to use the `.uiBottomSheet(...)` view modifier instead of instantiating this struct directly.
    /// The bottom sheet supports interactive dismissal via dragging and custom themes via `UIBottomSheetThemeProtocol`.
    public struct BottomSheet<Content: View, T: UIBottomSheetThemeProtocol>: View {
        /// A binding to the presentation state of the bottom sheet.
        @Binding private var isPresented: Bool
        /// A closure that returns the content to be displayed within the sheet.
        private let contentBuilder: () -> Content
        /// The visual style and behavior settings of the bottom sheet.
        private let theme: T
        
        @State private var offset: CGFloat = 0
        
        public init(
            isPresented: Binding<Bool>,
            theme: T,
            @ViewBuilder content: @escaping () -> Content
        ) {
            self._isPresented = isPresented
            self.theme = theme
            self.contentBuilder = content
        }
        
        public var body: some View {
            if isPresented {
                ZStack(alignment: .bottom) {
                    // Background Overlay
                    SwiftUI.Button {
                        withAnimation {
                            isPresented = false
                        }
                    } label: {
                        theme.overlayColor
                            .ignoresSafeArea()
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Dismiss")
                    .accessibilityHint("Double tap to close")
                    
                    // Sheet Content
                    SheetContent(
                        content: contentBuilder(),
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
}

extension UI.BottomSheet where T == UIBottomSheetTheme {
    public init(
        isPresented: Binding<Bool>,
        theme: UIBottomSheetTheme = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.theme = theme
        self.contentBuilder = content
    }
}

// MARK: - Sheet Content View
private struct SheetContent<Content: View, T: UIBottomSheetThemeProtocol>: View {
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
private struct BottomSheetModifier<SheetContent: View, T: UIBottomSheetThemeProtocol>: ViewModifier {
    @Binding var isPresented: Bool
    let theme: T
    @ViewBuilder let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            UI.BottomSheet(isPresented: $isPresented, theme: theme, content: sheetContent)
        }
    }
}

public extension View {
    func uiBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        theme: UIBottomSheetTheme = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheetModifier(
            isPresented: isPresented,
            theme: theme,
            sheetContent: content
        ))
    }
    
    func uiBottomSheet<Content: View, T: UIBottomSheetThemeProtocol>(
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
        .uiBottomSheet(isPresented: .constant(true)) {
            VStack(spacing: 20) {
                Text("Bottom Sheet Title")
                    .font(.headline)
                Text("This is a custom draggable bottom sheet. You can put any SwiftUI content here.")
                    .multilineTextAlignment(.center)
                
                UI.Button(title: "Done", style: .primary, action: {})
                    .padding(.horizontal)
            }
        }
}
