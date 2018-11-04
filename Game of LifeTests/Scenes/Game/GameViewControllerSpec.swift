import Quick
import Nimble
@testable import Game_of_Life

class GameBusinessLogicMock: GameBusinessLogic {
   
   var didStartCalled: ((_ request: Game.StartRequest) -> Void)?
   var didStopCalled: (() -> Void)?
   
   func start(request: Game.StartRequest) {
      didStartCalled?(request)
   }
   
   func stop() {
      didStopCalled?()
   }
}

class GameViewMock: GameView {
   
   var didDisplayCalled: ((_ universe: Universe) -> Void)?
   var didUpdateCalled: ((_ dimensions: Dimensions) -> Void)?
   
   override func display(universe: Universe) {
      didDisplayCalled?(universe)
   }
   
   override func update(byDimensions dimensions: Dimensions) {
      didUpdateCalled?(dimensions)
   }
}

class GameViewControllerSpec: QuickSpec {
   
   override func spec() {
      var viewController: GameViewController!
      beforeEach {
         viewController = GameViewController()
      }
      describe(".viewDidLoad()") {
         beforeEach {
            // Access the view to trigger GameViewController.viewDidLoad().
            let _ =  viewController.view
         }
         describe(".gameView") {
            it("is created") {
               expect(viewController.gameView).toNotEventually(beNil())
            }
            describe("methods") {
               var gameViewMock: GameViewMock!
               var displayExpectation: XCTestExpectation!
               var updateExpectation: XCTestExpectation!
               beforeEach {
                  gameViewMock = GameViewMock() //Hold because it it weak
                  viewController.gameView = gameViewMock
                  displayExpectation = QuickSpec.current.expectation(description: "displayExpectation")
                  updateExpectation = QuickSpec.current.expectation(description: "updateExpectation")
                  gameViewMock.didDisplayCalled = { _ in
                     displayExpectation.fulfill()
                  }
                  gameViewMock.didUpdateCalled = { _ in
                     updateExpectation.fulfill()
                  }
               }
               it("display & update") {
                  let dimensions = Dimensions(width: 10, height: 12)
                  gameViewMock.display(universe: Universe(dimensions: dimensions))
                  gameViewMock.update(byDimensions: dimensions)
                  QuickSpec.current.wait(for: [displayExpectation, updateExpectation], timeout: 1)
               }
            }
         }
      }
      
      describe("GameBusinessLogic") {
         var startExpectation: XCTestExpectation!
         var stopExpectation: XCTestExpectation!
         beforeEach {
            let interactor = GameBusinessLogicMock()
            viewController.interactor = interactor
            startExpectation = QuickSpec.current.expectation(description: "didStartCalled")
            stopExpectation = QuickSpec.current.expectation(description: "didStopCalled")
            interactor.didStartCalled = { _ in
               startExpectation.fulfill()
            }
            interactor.didStopCalled = {
               stopExpectation.fulfill()
            }
         }
         it("call start") {
            viewController.viewWillAppear(false)
            QuickSpec.current.wait(for: [startExpectation], timeout: 1)
            viewController.viewWillDisappear(false)
            QuickSpec.current.wait(for: [stopExpectation], timeout: 1)
         }
      }
      it("deinit") {
         weak var weakRef: GameViewController?
         weakRef = viewController
         viewController.beginAppearanceTransition(true, animated: false)
         viewController.endAppearanceTransition()
         viewController = nil
         expect(weakRef).toEventually(beNil())
      }
   }
}
