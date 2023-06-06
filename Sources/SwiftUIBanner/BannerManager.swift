//
//  File.swift
//  
//
//  Created by Emre Onder on 06/06/2023.
//

import Foundation
import SwiftUI

public class BannerManager: ObservableObject {
    public static let shared = BannerManager()

    @Published public var bannerData: BannerData?
    public var styles: BannerStyle = BannerStyle()
    public var dismissTime: Double = 2.0

    private var dismissalTimer: Timer?

    public func showBanner(data: BannerData) {
        bannerData = data
        dismissalTimer?.invalidate()
        dismissalTimer = Timer.scheduledTimer(withTimeInterval: dismissTime, repeats: false) { _ in
            withAnimation {
                self.dismissBanner()
            }
        }
    }

    public func dismissBanner() {
        bannerData = nil
    }
}
