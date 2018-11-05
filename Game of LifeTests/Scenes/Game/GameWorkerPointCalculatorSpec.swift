import Quick
import Nimble
@testable import Game_of_Life

class GameWorkerPointCalculatorSpec: QuickSpec {

   override func spec() {
      var calculator: GameWorkerPointCalculator!
      beforeEach {
         calculator = GameWorkerPointCalculator()
      }
      it("calculateIndexes(fromRequest:dimensions:)") {
         let dimension = Game.Model.Dimensions(width: 10, height: 10)
         let viewSize = CGSize(width: 100, height: 100)
         let location = CGPoint(x: 15, y: 35)
         let result = calculator.calculateIndexes(fromLocation: location, viewSize: viewSize, dimensions: dimension)
         expect(result.row).toEventually(be(3))
         expect(result.column).toEventually(be(1))
      }
   }
}
