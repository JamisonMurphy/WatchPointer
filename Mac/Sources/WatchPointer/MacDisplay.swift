import SwiftUI

/// A Mac display outline: rounded corners, with the notch cut into the top edge on MacBooks.
/// (Same shape is in the watch app.)
struct MacDisplay: Shape {
    var notch = true // external monitors have none

    func path(in r: CGRect) -> Path {
        guard notch else {
            return Path(roundedRect: r, cornerRadius: min(r.width, r.height) * 0.07, style: .continuous)
        }
        let corner = min(r.width, r.height) * 0.07
        // Real proportions: the notch is ~12% of the width and ~3.3% of the height; a bit taller here so it reads.
        let notchWidth = r.width * 0.12
        let notchHeight = max(r.height * 0.05, 4)
        let notchRadius = notchHeight * 0.6
        let left = r.midX - notchWidth / 2, right = r.midX + notchWidth / 2

        var p = Path()
        p.move(to: CGPoint(x: r.minX + corner, y: r.minY))
        p.addLine(to: CGPoint(x: left, y: r.minY))
        p.addLine(to: CGPoint(x: left, y: r.minY + notchHeight - notchRadius))
        p.addQuadCurve(to: CGPoint(x: left + notchRadius, y: r.minY + notchHeight),
                       control: CGPoint(x: left, y: r.minY + notchHeight))
        p.addLine(to: CGPoint(x: right - notchRadius, y: r.minY + notchHeight))
        p.addQuadCurve(to: CGPoint(x: right, y: r.minY + notchHeight - notchRadius),
                       control: CGPoint(x: right, y: r.minY + notchHeight))
        p.addLine(to: CGPoint(x: right, y: r.minY))
        p.addLine(to: CGPoint(x: r.maxX - corner, y: r.minY))
        p.addArc(tangent1End: CGPoint(x: r.maxX, y: r.minY), tangent2End: CGPoint(x: r.maxX, y: r.maxY), radius: corner)
        p.addArc(tangent1End: CGPoint(x: r.maxX, y: r.maxY), tangent2End: CGPoint(x: r.minX, y: r.maxY), radius: corner)
        p.addArc(tangent1End: CGPoint(x: r.minX, y: r.maxY), tangent2End: CGPoint(x: r.minX, y: r.minY), radius: corner)
        p.addArc(tangent1End: CGPoint(x: r.minX, y: r.minY), tangent2End: CGPoint(x: r.maxX, y: r.minY), radius: corner)
        p.closeSubpath()
        return p
    }
}
