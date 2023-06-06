//
//  File.swift
//  
//
//  Created by Emre Onder on 06/06/2023.
//

import Foundation
import SwiftUI

struct BannerView: View {
    var banner: BannerData
    var onDismiss: () -> Void
    
    @GestureState private var dragState = DragState.inactive
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false // Track drag gesture state
    @EnvironmentObject private var bannerManager: BannerManager
    
    var style: BannerStyle.SubStyle {
        banner.type.style
    }
    
    var body: some View {
        VStack {
            HStack {
                if let icon = style.icon {
                    icon
                        .font(.title)
                        .foregroundColor(style.tintColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(banner.title)
                        .font(bannerManager.styles.titleFont)
                    if let subtitle = banner.subtitle {
                        Text(subtitle)
                            .font(bannerManager.styles.subtitleFont)
                    }
                }
                Spacer()
            }
            .foregroundColor(Color.white)
            .padding(16)
            .background(style.backgroundColor)
            .cornerRadius(bannerManager.styles.cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 15)
            Spacer()
        }
        .padding()
        .transition(AnyTransition.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                             removal: .move(edge: .top).combined(with: .opacity)))
        .offset(y: isDragging ? dragOffset + dragState.translation.height : 0)
        .animation(.easeInOut) // Animation for appearance and disappearance
        .gesture(
            DragGesture()
                .updating($dragState) { value, state, _ in
                    state = .dragging(translation: value.translation)
                }
                .onChanged { _ in
                    isDragging = true // Start tracking dragging
                }
                .onEnded { value in
                    let threshold = UIScreen.main.bounds.height * 0.25
                    if abs(value.translation.height) > threshold {
                        withAnimation(.easeInOut) { // Add animation for dismissal
                            onDismiss()
                        }
                    } else {
                        withAnimation {
                            isDragging = false // Stop tracking dragging
                            dragOffset = 0
                        }
                    }
                }
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    onDismiss()
                }
            }
        }
        .id(banner.id)
    }
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .dragging(translation: .zero):
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
        ZStack {
            content
            if let banner = currentBanner {
                BannerView(banner: banner) {
                    withAnimation {
                        currentBanner = nil
                    }
                }
            }
        }
        .onReceive(bannerManager.$bannerData) { bannerData in
            guard let banner = bannerData else { return }
            currentBanner = banner
        }
    }
}
