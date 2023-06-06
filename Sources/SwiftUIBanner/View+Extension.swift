//
//  File.swift
//  
//
//  Created by Emre Onder on 06/06/2023.
//

import Foundation
import SwiftUI

public extension View {
    func banner(data: Binding<BannerData?>) -> some View {
        self.modifier(BannerModifier())
            .onChange(of: data.wrappedValue) { newData in
                if let newData = newData {
                    BannerManager.shared.showBanner(data: newData)
                }
            }
    }
}
