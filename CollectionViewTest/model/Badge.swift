struct Badge: Decodable, Equatable {
    let achieved: Bool
    let code: String
    let name: String
    let displayPriority: Int
    let startDate: String
    let endDate: String
    let category: BadgeCategory
    let tracker: BadgeTracker
    let attributes: [BadgeAttributes]
    let description: String
    
    struct BadgeAttributes: Codable, Equatable {
        let code: String
        let value: String
    }
    
    struct BadgeCategory: Codable, Equatable {
        let code: String
        let name: String
    }
    
    struct BadgeTracker: Codable, Equatable {
        let maxValue: Int
        let currValue: Int
    }
}
