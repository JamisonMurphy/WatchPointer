import AppKit

/// All connected displays, in global screen coordinates (as arranged in System Settings › Displays).
enum Displays {
    static var all: [CGDirectDisplayID] {
        var count: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &count)
        var ids = [CGDirectDisplayID](repeating: 0, count: Int(count))
        CGGetActiveDisplayList(count, &ids, &count)
        return ids.isEmpty ? [CGMainDisplayID()] : ids
    }

    /// The display under `p`, or the nearest one when `p` is off every screen.
    static func display(containing p: CGPoint) -> CGDirectDisplayID {
        all.min { distance(p, CGDisplayBounds($0)) < distance(p, CGDisplayBounds($1)) } ?? CGMainDisplayID()
    }

    static func bounds(containing p: CGPoint) -> CGRect { CGDisplayBounds(display(containing: p)) }

    /// `p` if it is on a display, else the closest point on the nearest display (so gaps between screens are skipped).
    static func clamp(_ p: CGPoint) -> CGPoint {
        let r = bounds(containing: p)
        return CGPoint(x: min(max(p.x, r.minX), r.maxX - 1), y: min(max(p.y, r.minY), r.maxY - 1))
    }

    private static func distance(_ p: CGPoint, _ r: CGRect) -> CGFloat {
        hypot(max(r.minX - p.x, 0, p.x - r.maxX + 1), max(r.minY - p.y, 0, p.y - r.maxY + 1))
    }
}

extension NSScreen {
    var displayID: CGDirectDisplayID? { deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID }
}
