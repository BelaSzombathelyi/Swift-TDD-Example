import UIKit

protocol GameBusinessLogic {
   func start(request: Game.StartRequest)
   func stop()
}

protocol GameDataStore {
   var currentUniverse: Game.Universe? { get set }
}

class GameInteractor: GameBusinessLogic, GameDataStore {
   var presenter: GamePresentationLogic?
   let worker = GameWorker()
   var currentUniverse: Game.Universe?
   
   private var timer: Timer?
   
   // MARK: Scrolling to next step
   
   func start(request: Game.StartRequest) {
      timer?.invalidate()
      self.scrollingToNextStep()
      timer = Timer.scheduledTimer(withTimeInterval: request.stepTimeInterval, repeats: true) { [weak self] _ in
         guard let self = self else { return }
         self.scrollingToNextStep()
      }
   }
   
   func scrollingToNextStep() {
      guard let universe = self.currentUniverse else { assertionFailure(); return }
      let nextUniverse = worker.calculateNextStep(fromUniverse: universe)
      let response = Game.NextStepResponse(universe: nextUniverse)
      self.currentUniverse = nextUniverse
      presenter?.presentNextUniverse(response: response)
   }
   
   func stop() {
      timer?.invalidate()
   }
   
   deinit {
      stop()
   }
}

