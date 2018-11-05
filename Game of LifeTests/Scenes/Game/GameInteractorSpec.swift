import Quick
import Nimble
@testable import Game_of_Life


class GamePresentationLogicMock: GamePresentationLogic {
   
   var didPresentNextUniverseCalled: (_ response: Game.DisplayLoop.Response) -> Void = { _ in }
   
   func presentNextUniverse(response: Game.DisplayLoop.Response) {
      didPresentNextUniverseCalled(response)
   }
}


class GameInteractorSpec: QuickSpec {

   override func spec() {
      var interactor: GameInteractor!
      var dimensions: Game.Model.Dimensions!
      var universe: Game.Model.Universe!
      var fakePresenter: GamePresentationLogicMock!
      beforeEach {
         func generateSize() -> UInt8 {
            return 1 + UInt8(arc4random_uniform(100))
         }
         dimensions = Game.Model.Dimensions(width: generateSize(), height: generateSize())
         fakePresenter = GamePresentationLogicMock()
         interactor = GameInteractor()
         universe = Game.Model.Universe(dimensions: dimensions)
         interactor.presenter = fakePresenter
         interactor.currentUniverse = universe
      }
      describe("GameDataStore.currentUniverse") {
         it("not nil") {
            var gameDataStore: GameDataStore = interactor
            gameDataStore.currentUniverse = Game.Model.Universe(dimensions: dimensions)
            expect(gameDataStore.currentUniverse).toEventuallyNot(beNil())
         }
      }
      
      // Slow tests
      describe("GameBusinessLogic") {
         var businessLogic: GameBusinessLogic!
         var counter: Int!
         beforeEach {
            counter = 0
            businessLogic = interactor
            fakePresenter.didPresentNextUniverseCalled = { _ in
               counter += 1
            }
         }
         afterEach {
            businessLogic?.stop()
         }
         it("call present the new Universe immediately") {
            let request = Game.DisplayLoop.Request(stepTimeInterval: 3)
            businessLogic.start(request: request)
            expect(counter).toEventually(be(1))
         }
         context("call PresentNextUniverse") {
            let stepTimeInterval: TimeInterval = 1
            let stepCount = 3
            var startTime: Date!
            var endTime: Date!
            var lastCount: Int!
            var reachCountExpectation: XCTestExpectation!
            beforeEach {
               startTime = nil
               endTime = nil
               lastCount = nil
               reachCountExpectation = QuickSpec.current.expectation(description: "Counter reached")
               fakePresenter.didPresentNextUniverseCalled = { _ in
                  if (counter == 0) {
                     startTime = Date()
                  }
                  counter += 1
                  if (counter == lastCount) {
                     endTime = Date()
                     reachCountExpectation.fulfill()
                  }
               }
            }
            let expectedTime = stepTimeInterval * TimeInterval(stepCount - 1)
            let request = Game.DisplayLoop.Request(stepTimeInterval: stepTimeInterval)
            let timeout = expectedTime + (stepTimeInterval + 0.5)

            it("called once") {
               lastCount = stepCount
               businessLogic.start(request: request)
               QuickSpec.current.wait(for: [reachCountExpectation], timeout: timeout)
               let neededTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
               expect(expectedTime).to(beCloseTo(neededTime, within: stepTimeInterval / 2))
               expect(counter).toEventually(be(lastCount))
            }
            it("called twice") {
               lastCount = stepCount + 1
               businessLogic.start(request: request)
               let request2 = Game.DisplayLoop.Request(stepTimeInterval: stepTimeInterval)
               businessLogic.start(request: request2)
               QuickSpec.current.wait(for: [reachCountExpectation], timeout: timeout)
               let neededTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
               expect(expectedTime).to(beCloseTo(neededTime, within: stepTimeInterval / 2))
               expect(counter).toEventually(be(lastCount))
            }
            it("stop") {
               lastCount = 0
               reachCountExpectation.isInverted = true
               businessLogic.start(request: request)
               businessLogic.stop()
               let timeout = stepTimeInterval + 0.5
               QuickSpec.current.wait(for: [reachCountExpectation], timeout: timeout)
               expect(counter).toEventually(be(1))
            }
         }
      }
      
      describe("deinit") {
         weak var weakRef: GameInteractor?
         beforeEach {
            weakRef = interactor
         }
         it("") {
            weakRef!.start(request: Game.DisplayLoop.Request(stepTimeInterval: 3))
            interactor = nil
            expect(weakRef).toEventually(beNil())
         }
      }
   }
}
