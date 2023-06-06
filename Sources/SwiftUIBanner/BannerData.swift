//
//  File.swift
//  
//
//  Created by Emre Onder on 06/06/2023.
//

import Foundation
import SwiftUI

public struct BannerData: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let type: BannerType
    
    public init(title: String, subtitle: String? = nil, type: BannerType) {
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }

}

public enum BannerType {
    case info
    case warning
    case success
    case error
    
    var style: BannerStyle.SubStyle {
        switch self {
        case .info:
            return BannerManager.shared.styles.info
        case .warning:
            return BannerManager.shared.styles.warning
        case .success:
            return BannerManager.shared.styles.success
        case .error:
            return BannerManager.shared.styles.error
        }
    }
}
