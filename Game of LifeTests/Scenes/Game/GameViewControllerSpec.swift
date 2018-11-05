import Quick
import Nimble
@testable import Game_of_Life

class GameBusinessLogicMock: GameBusinessLogic {
   
   var didStartCalled: ((_ request: Game.DisplayLoop.Request) -> Void)?
   var didUserInputCalled: ((_ request: Game.UserInputAction.Request) -> Void)?
   var didUpdateCalled: (() -> Void)?
   var didStopCalled: (() -> Void)?
   
   func start(request: Game.DisplayLoop.Request) {
      didStartCalled?(request)
   }
   
   func update() {
      didUpdateCalled?();
   }
   
   func stop() {
      didStopCalled?()
   }
   
   func userInput(request: Game.UserInputAction.Request) {
      didUserInputCalled?(request)
   }
}

class GameViewMock: GameView {
   
   var didDisplayCalled: ((_ universe: Game.Model.Universe) -> Void)?
   var didUpdateCalled: ((_ dimensions: Game.Model.Dimensions) -> Void)?
   
   override func display(universe: Game.Model.Universe) {
      super.display(universe: universe)
      didDisplayCalled?(universe)
   }
   
   override func update(byDimensions dimensions: Game.Model.Dimensions) {
      super.update(byDimensions: dimensions)
      didUpdateCalled?(dimensions)
   }
}


class TapGestureRecognizerMock: UITapGestureRecognizer {
   
   var storedLocation: CGPoint?
   
   override func location(in view: UIView?) -> CGPoint {
      if let storedLocation = storedLocation {
         return storedLocation
      }
      return super.location(in: view)
   }
}


class GameViewControllerSpec: QuickSpec {
   
   override func spec() {
      var viewController: GameViewController!
      var tapGestureRecognizer: TapGestureRecognizerMock!
      beforeEach {
         viewController = GameViewController()
         tapGestureRecognizer = TapGestureRecognizerMock(target: viewController, action: #selector(GameViewController.onTapRecognizedOnGameView(_:)))
         viewController.tapRecognizer = tapGestureRecognizer
         let _ =  viewController.view
         viewController.beginAppearanceTransition(true, animated: false)
         viewController.endAppearanceTransition()
      }

      it(".gameView is created") {
         expect(viewController.gameView).toNot(beNil())
      }
      describe(".gameView") {
         var gameViewMock: GameViewMock!
         var displayExpectation: XCTestExpectation!
         var updateExpectation: XCTestExpectation!
         beforeEach {
            gameViewMock = GameViewMock() //Hold because it is weak
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
         it("display() and update()") {
            viewController.interactor?.start(request: Game.DisplayLoop.Request(stepTimeInterval: 3))
            QuickSpec.current.wait(for: [displayExpectation, updateExpectation], timeout: 1)
         }
      }
      it(".tapGestureRecognizer") {
         let size = CGSize(width: 300, height: 300)
         viewController.gameView.bounds = CGRect(origin: .zero, size: size)
         let dimensions = Game.Model.Dimensions(width: 10, height: 10)
         let universe = Game.Model.Universe(dimensions: dimensions, randomFill: true)
         (viewController.interactor as? GameInteractor)?.currentUniverse = universe
         let tileHeight = size.height / CGFloat(dimensions.height)
         let tileWidth = size.width / CGFloat(dimensions.width)
         let row = Int(arc4random_uniform(UInt32(dimensions.height)))
         let column = Int(arc4random_uniform(UInt32(dimensions.width)))
         let oldValue = universe.cells[row][column]
         let location = CGPoint(x: tileWidth * (CGFloat(column) + 0.5), y: tileHeight * (CGFloat(row) + 0.5))
         tapGestureRecognizer.storedLocation = location
         
         viewController.onTapRecognizedOnGameView(tapGestureRecognizer)
         
         let newUniverse = (viewController.interactor as! GameDataStore).currentUniverse!
         let newValue = newUniverse.cells[row][column]
         expect(oldValue).toNot(be(newValue))
         if (oldValue) {
            expect(universe.count(ofValue: false) + 1).toEventually(be(newUniverse.count(ofValue: false)))
         } else {
            expect(universe.count(ofValue: true) + 1).toEventually(be(newUniverse.count(ofValue: true)))
         }
      }
      
      it(".didSelectPlayButton()") {
         expect(viewController.stopButton.isHidden).toEventually(beTrue())
         viewController.playButton.sendActions(for: .touchUpInside)
         expect(viewController.playButton.isHidden).toEventually(beTrue())
         expect(viewController.stopButton.isHidden).toEventually(beFalse())
         expect(viewController.randomButton.isEnabled).toEventually(beFalse())
      }
      it(".didSelectStopButton()") {
         viewController.playButton.sendActions(for: .touchUpInside)
         expect(viewController.playButton.isHidden).toEventually(beTrue())
         viewController.stopButton.sendActions(for: .touchUpInside)
         expect(viewController.playButton.isHidden).toEventually(beFalse())
         expect(viewController.randomButton.isEnabled).toEventually(beTrue())
      }
      it(".didSelectRandomButton()") {
         viewController.randomButton.sendActions(for: .touchUpInside)
         expect(viewController.playButton.isEnabled).toEventually(beTrue())
         expect(viewController.randomButton.isEnabled).toEventually(beTrue())
         expect(viewController.stopButton.isHidden).toEventually(beTrue())
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
         it(".start()") {
            stopExpectation.isInverted = true
            viewController.playButton.sendActions(for: .touchUpInside)
            QuickSpec.current.wait(for: [startExpectation, stopExpectation], timeout: 1)
         }
         it(".stop()") {
            viewController.playButton.sendActions(for: .touchUpInside)
            QuickSpec.current.wait(for: [startExpectation], timeout: 1)
            viewController.stopButton.sendActions(for: .touchUpInside)
            QuickSpec.current.wait(for: [stopExpectation], timeout: 1)
         }
      }
   }
}
