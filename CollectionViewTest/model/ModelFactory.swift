import Foundation

final class ModelFactory {
    
    static func makeMissionModel() -> MissionListDetailViewModel? {
        guard let categories = try? JSONDecoder().decode([LoyaltyCategory].self, from: getData(name: "categories")),
              let badges = try? JSONDecoder().decode([Badge].self, from: getData(name: "badges")) else {
            return nil
        }
        let model = MissionListDetailViewModel(loyaltyCategories: categories, badges: badges)
        return model
    }
    
    static func getData(name: String, withExtension: String = "json") -> Data {
        let path = Bundle.main.path(forResource: name, ofType: withExtension)
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return data
    }
}
