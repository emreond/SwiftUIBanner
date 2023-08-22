import Foundation
import SwiftUI

struct BannerView: View {
    var banner: BannerData
    var onDismiss: () -> Void
    
    @GestureState private var dragState = DragState.inactive
    @State private var timer: Timer?
    @State private var isDragging: Bool = false // Track drag gesture state
    @EnvironmentObject private var bannerManager: BannerManager
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var style: BannerStyle.SubStyle {
        banner.type.style
    }
    
    var body: some View {
        VStack {
            bannerContent
                .padding(.horizontal, 16)
                .padding(.top, safeAreaInsets.top)
                .offset(y: dragState.translation.height)
                .onAppear {
                    startTimer()
                }
        }
        .contentShape(Rectangle())
        .gesture(dragGesture)
        .transition(AnyTransition.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                             removal: .move(edge: .top).combined(with: .opacity)))
        .animation(.easeInOut)
        .id(banner.id)
        .onChange(of: dragState) { newState in
                    if case .inactive = newState {
                        startTimer()
                    } else {
                        timer?.invalidate()
                    }
                }
    }
    
    private var bannerContent: some View {
        HStack {
            if let icon = style.icon {
                icon
                    .font(.title)
                    .foregroundColor(style.tintColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(banner.title)
                    .font(bannerManager.styles.titleFont)
                    .foregroundColor(style.tintColor)
                if let subtitle = banner.subtitle {
                    Text(subtitle)
                        .font(bannerManager.styles.subtitleFont)
                        .foregroundColor(style.tintColor)
                }
            }
            Spacer()
        }
        .padding(16)
        .background(
            style.backgroundColor
                .cornerRadius(bannerManager.styles.cornerRadius)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 15)
        )
    }
    
    private func startTimer() {
          timer?.invalidate()
          timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
              if case .inactive = dragState {
                  withAnimation(.easeInOut) {
                      onDismiss()
                  }
              }
          }
      }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragState) { value, state, _ in
                state = .dragging(translation: value.translation)
            }
            .onEnded { value in
                let threshold = UIScreen.main.bounds.height * 0.25
                if abs(value.translation.height) > threshold {
                    withAnimation {
                        onDismiss()
                    }
                }
            }
    }

    enum DragState: Equatable {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
    }
}

struct BannerModifier: ViewModifier {
    @EnvironmentObject var bannerManager: BannerManager
    @State private var currentBanner: BannerData?

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if let banner = currentBanner {
                BannerView(banner: banner) {
                    withAnimation {
                        currentBanner = nil
                    }
                }
                .zIndex(1)
                .edgesIgnoringSafeArea(.top)
            }
        }
        .onReceive(bannerManager.$bannerData) { bannerData in
            guard let banner = bannerData else { return }
            currentBanner = banner
        }
    }
}

