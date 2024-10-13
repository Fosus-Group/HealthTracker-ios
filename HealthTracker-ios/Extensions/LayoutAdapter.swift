//
//  LayoutAdapter.swift
//  HealthTracker-ios
//
//  Created by sergey on 13.10.2024.
//

import UIKit

func adapt(_ constant: CGFloat, for axis: UIAxis) -> CGFloat {
    let screenSize = UIScreen.main.bounds.size
    let ratio: CGFloat
    switch axis {
    case .horizontal:
        ratio = screenSize.width / Constants.baseDeviceSize.width
    default:
        ratio = screenSize.height / Constants.baseDeviceSize.height
    }
    return constant * ratio
}

extension Int {
    var VAdapted: CGFloat {
        adapt(CGFloat(self), for: .vertical)
    }
    var HAdapted: CGFloat {
        adapt(CGFloat(self), for: .horizontal)
    }
}

extension CGFloat {
    var VAdapted: CGFloat {
        adapt(self, for: .vertical)
    }
    var HAdapted: CGFloat {
        adapt(self, for: .horizontal)
    }
}

extension CGSize {
    var adapted: CGSize {
        let w = adapt(self.width, for: .horizontal)
        let h = adapt(self.height, for: .vertical)
        return CGSize(width: w, height: h)
    }
}

extension UIFont {
    var adapted: UIFont {
        return self.withSize(self.pointSize.HAdapted)
    }
}
