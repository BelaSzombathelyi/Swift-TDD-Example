import UIKit

protocol GameBusinessLogic {
   func start(stepTimeInterval: TimeInterval)
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
   
   private func scrollingToNextStep(request: Game.NextStepRequest) {
      let nextUniverse = worker.calculateNextStep(fromUniverse: request.universe)
      let response = Game.NextStepResponse(universe: nextUniverse)
      self.currentUniverse = nextUniverse
      presenter?.presentNextUniverse(response: response)
   }
   
   func start(stepTimeInterval: TimeInterval) {
      timer?.invalidate()
      timer = Timer.scheduledTimer(withTimeInterval: stepTimeInterval, repeats: true) { [weak self] _ in
         guard let self = self else { return }
         guard let universe = self.currentUniverse else { assertionFailure(); return }
         let request = Game.NextStepRequest(universe: universe)
         self.scrollingToNextStep(request: request)
      }
   }
}

