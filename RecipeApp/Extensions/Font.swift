//
//  Font.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//

import SwiftUI

enum OpenSansType {
    case regular
    case medium
    case bold
    
    var String: String {
        switch self {
        case .regular:
            return "OpenSans-Regular"
        case .medium:
            return "OpenSans-Medium"
        case .bold:
            return "OpenSans-Bold"
        }
    }
}

extension Font {
    static func customOpenSans(openSansType: OpenSansType, size: CGFloat, textStyle: TextStyle) -> Font {
        return Font.custom(openSansType.String, size: size, relativeTo: textStyle)
    }

}
