import Testing
@testable import jokester_deck

struct GameUnlockServiceTests {

    @Test func level1Unlocks25() {
        #expect(GameUnlockService.unlockedCount(for: 1) == 25)
    }

    @Test func level3Unlocks50() {
        #expect(GameUnlockService.unlockedCount(for: 3) == 50)
    }

    @Test func level6Unlocks100OrCatalogMax() {
        let count = GameUnlockService.unlockedCount(for: 6)
        #expect(count == min(100, GameUnlockService.totalCatalogCount))
    }

    @Test func nextTierFromLevel1() {
        let next = GameUnlockService.nextTier(after: 1)
        #expect(next?.requiredLevel == 3)
        #expect(next?.gameCount == 50)
    }
}
