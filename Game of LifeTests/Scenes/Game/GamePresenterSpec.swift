import Quick
import Nimble
@testable import Game_of_Life

class GameDisplayLogicMock: GameDisplayLogic {
   
   var didDisplayUniverseCalled: (_ viewModel: Game.DisplayLoop.ViewModel) -> Void = { _ in }
   
   func displayUniverse(viewModel: Game.DisplayLoop.ViewModel) {
      didDisplayUniverseCalled(viewModel)
   }
}


class GamePresenterDeinit: GamePresenter {}


class GamePresenterSpec: QuickSpec {
   
   override func spec() {
      let dimensions = Game.Model.Dimensions(width: 3, height: 3)
      let universe = Game.Model.Universe(dimensions: dimensions)
      let response = Game.DisplayLoop.Response(universe: universe)

      describe("displayUniverse viewModel") {
         let displayLogic = GameDisplayLogicMock()
         let presenter = GamePresenter()
         presenter.viewController = displayLogic
         
         it("is call displayUniverse") {
            displayLogic.didDisplayUniverseCalled = { viewModel in
               expect(viewModel.universe.cells == universe.cells).toEventually(beTrue())
            }
            presenter.presentNextUniverse(response: response)
         }
         it("is call displayUniverse only once") {
            var counter = 0
            displayLogic.didDisplayUniverseCalled = { viewModel in
               counter += 1
            }
            presenter.presentNextUniverse(response: response)
            expect(counter).toEventually(be(1))
         }
      }
      describe("deinit()") {
         var presenter: GamePresenter!
         beforeEach {
            presenter = GamePresenter()
            let displayLogic = GameDisplayLogicMock()
            presenter.viewController = displayLogic
         }
         it("with an unused object") {
            weak var weakRef = presenter
            presenter = nil
            expect(weakRef).toEventually(beNil())
         }
         it("with an used object") {
            weak var weakRef = presenter
            presenter.presentNextUniverse(response: response)
            presenter = nil
            expect(weakRef).toEventually(beNil())
         }
      }
   }
}
