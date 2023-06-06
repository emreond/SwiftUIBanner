//
//  File.swift
//  
//
//  Created by Emre Onder on 06/06/2023.
//

import Foundation
import SwiftUI

public struct BannerStyle {
    public var titleFont: Font = .body
    public var subtitleFont: Font = .body
    public var cornerRadius: CGFloat = 10.0

    public var success = SubStyle(backgroundColor: .green)
    public var error = SubStyle(backgroundColor: .red)
    public var info = SubStyle(backgroundColor: .gray)
    public var warning = SubStyle(backgroundColor: .yellow)

    public struct SubStyle {
        public var backgroundColor: Color = .green
        public var tintColor: Color = .white
        public var icon: Image?
        
        init(backgroundColor: Color, tintColor: Color = .white, icon: Image? = nil) {
            self.backgroundColor = backgroundColor
            self.tintColor = tintColor
            self.icon = icon
        }
    }
}
