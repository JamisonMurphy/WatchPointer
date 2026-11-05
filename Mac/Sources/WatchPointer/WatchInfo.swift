import Foundation

/// What the watch reports about itself on connect (and every minute for the battery).
struct WatchInfo: Decodable, Equatable {
    let model: String   // hardware id, e.g. "Watch7,15"
    let os: String
    let battery: Int    // percent, -1 when unknown
    let charging: Bool
    let name: String

    /// Marketing name, e.g. "Apple Watch SE 3". Unknown (newer) ids fall back to plain "Apple Watch".
    var modelName: String { WatchInfo.models[model]?.name ?? "Apple Watch" }
    /// Case and connectivity, e.g. "GPS + Cellular, 40mm". Empty when the database doesn't list one.
    var variant: String { WatchInfo.models[model]?.variant ?? "" }

    /// Compact line for the notch, e.g. "40mm · Cellular · watchOS 27.0" (Cellular models include GPS).
    var subtitle: String {
        let parts = variant.components(separatedBy: ", ")
        let size = parts.first { $0.hasSuffix("mm") }
        let radio = variant.contains("Cellular") ? "Cellular" : nil
        return [size, radio, "watchOS \(os)"].compactMap { $0 }.joined(separator: " · ")
    }

    /// Every released Apple Watch identifier, from AppleDB (api.appledb.dev/device/main.json, Nov 2026), cross-checked
    /// against ipsw.me (api.ipsw.me/v4/devices, lists up to Series 5) and the community list at
    /// gist.github.com/adamawolf/3048717 (up to Series 11 / Ultra 3 / SE 3). Fixes from that check:
    /// Watch5,11 is 40mm (AppleDB said 44mm); Ultra models are 49mm, Cellular. Watch8,x names are AppleDB-only.
    static let models: [String: (name: String, variant: String)] = [
        "Watch1,1": ("Apple Watch (1st generation)", "38mm"),
        "Watch1,2": ("Apple Watch (1st generation)", "42mm"),
        "Watch2,3": ("Apple Watch Series 2", "38mm"),
        "Watch2,4": ("Apple Watch Series 2", "42mm"),
        "Watch2,6": ("Apple Watch Series 1", "38mm"),
        "Watch2,7": ("Apple Watch Series 1", "42mm"),
        "Watch3,1": ("Apple Watch Series 3", "GPS + Cellular, 38mm"),
        "Watch3,2": ("Apple Watch Series 3", "GPS + Cellular, 42mm"),
        "Watch3,3": ("Apple Watch Series 3", "GPS, 38mm"),
        "Watch3,4": ("Apple Watch Series 3", "GPS, 42mm"),
        "Watch4,1": ("Apple Watch Series 4", "GPS, 40mm"),
        "Watch4,2": ("Apple Watch Series 4", "GPS, 44mm"),
        "Watch4,3": ("Apple Watch Series 4", "GPS + Cellular, 40mm"),
        "Watch4,4": ("Apple Watch Series 4", "GPS + Cellular, 44mm"),
        "Watch5,1": ("Apple Watch Series 5", "GPS, 40mm"),
        "Watch5,2": ("Apple Watch Series 5", "GPS, 44mm"),
        "Watch5,3": ("Apple Watch Series 5", "GPS + Cellular, 40mm"),
        "Watch5,4": ("Apple Watch Series 5", "GPS + Cellular, 44mm"),
        "Watch5,9": ("Apple Watch SE (1st generation)", "GPS, 40mm"),
        "Watch5,10": ("Apple Watch SE (1st generation)", "GPS, 44mm"),
        "Watch5,11": ("Apple Watch SE (1st generation)", "GPS + Cellular, 40mm"),
        "Watch5,12": ("Apple Watch SE (1st generation)", "GPS + Cellular, 44mm"),
        "Watch6,1": ("Apple Watch Series 6", "GPS, 40mm"),
        "Watch6,2": ("Apple Watch Series 6", "GPS, 44mm"),
        "Watch6,3": ("Apple Watch Series 6", "GPS + Cellular, 40mm"),
        "Watch6,4": ("Apple Watch Series 6", "GPS + Cellular, 44mm"),
        "Watch6,6": ("Apple Watch Series 7", "GPS, 41mm"),
        "Watch6,7": ("Apple Watch Series 7", "GPS, 45mm"),
        "Watch6,8": ("Apple Watch Series 7", "GPS + Cellular, 41mm"),
        "Watch6,9": ("Apple Watch Series 7", "GPS + Cellular, 45mm"),
        "Watch6,10": ("Apple Watch SE (2nd generation)", "GPS, 40mm"),
        "Watch6,11": ("Apple Watch SE (2nd generation)", "GPS, 44mm"),
        "Watch6,12": ("Apple Watch SE (2nd generation)", "GPS + Cellular, 40mm"),
        "Watch6,13": ("Apple Watch SE (2nd generation)", "GPS + Cellular, 44mm"),
        "Watch6,14": ("Apple Watch Series 8", "GPS, 41mm"),
        "Watch6,15": ("Apple Watch Series 8", "GPS, 45mm"),
        "Watch6,16": ("Apple Watch Series 8", "GPS + Cellular, 41mm"),
        "Watch6,17": ("Apple Watch Series 8", "GPS + Cellular, 45mm"),
        "Watch6,18": ("Apple Watch Ultra", "GPS + Cellular, 49mm"),
        "Watch7,1": ("Apple Watch Series 9", "GPS, 41mm"),
        "Watch7,2": ("Apple Watch Series 9", "GPS, 45mm"),
        "Watch7,3": ("Apple Watch Series 9", "GPS + Cellular, 41mm"),
        "Watch7,4": ("Apple Watch Series 9", "GPS + Cellular, 45mm"),
        "Watch7,5": ("Apple Watch Ultra 2", "GPS + Cellular, 49mm"),
        "Watch7,8": ("Apple Watch Series 10", "GPS, 42mm"),
        "Watch7,9": ("Apple Watch Series 10", "GPS, 46mm"),
        "Watch7,10": ("Apple Watch Series 10", "GPS + Cellular, 42mm"),
        "Watch7,11": ("Apple Watch Series 10", "GPS + Cellular, 46mm"),
        "Watch7,12": ("Apple Watch Ultra 3", "GPS + Cellular, 49mm"),
        "Watch7,13": ("Apple Watch SE 3", "GPS, 40mm"),
        "Watch7,14": ("Apple Watch SE 3", "GPS, 44mm"),
        "Watch7,15": ("Apple Watch SE 3", "GPS + Cellular, 40mm"),
        "Watch7,16": ("Apple Watch SE 3", "GPS + Cellular, 44mm"),
        "Watch7,17": ("Apple Watch Series 11", "GPS, 42mm"),
        "Watch7,18": ("Apple Watch Series 11", "GPS, 46mm"),
        "Watch7,19": ("Apple Watch Series 11", "GPS + Cellular, 42mm"),
        "Watch7,20": ("Apple Watch Series 11", "GPS + Cellular, 46mm"),
        "Watch8,1": ("Apple Watch Ultra 4", "GPS + Cellular, 49mm"),
        "Watch8,2": ("Apple Watch Series 12", "GPS, 42mm"),
        "Watch8,3": ("Apple Watch Series 12", "GPS, 46mm"),
        "Watch8,4": ("Apple Watch Series 12", "GPS + Cellular, 42mm"),
        "Watch8,5": ("Apple Watch Series 12", "GPS + Cellular, 46mm"),
    ]
}
