import UIKit

protocol GameBusinessLogic {
   func start(request: Game.DisplayLoop.Request)
   func update()
   func userInput(request: Game.UserInputAction.Request)
   func stop()
}

protocol GameDataStore {
   var currentUniverse: Game.Model.Universe? { get set }
}

class GameInteractor: GameBusinessLogic, GameDataStore {
   var presenter: GamePresentationLogic?
   let worker = GameWorker()
   let pointWorker = GameWorkerPointCalculator()
   var currentUniverse: Game.Model.Universe?
   
   private var timer: Timer?
   
   // MARK: Scrolling to next step
   
   func update() {
      guard let currentUniverse = self.currentUniverse else { assertionFailure(); return }
      let response = Game.DisplayLoop.Response(universe: currentUniverse)
      presenter?.presentNextUniverse(response: response)
   }
   
   func start(request: Game.DisplayLoop.Request) {
      timer?.invalidate()
      self.scrollingToNextStep()
      timer = Timer.scheduledTimer(withTimeInterval: request.stepTimeInterval, repeats: true) { [weak self] _ in
         guard let self = self else { return }
         self.scrollingToNextStep()
      }
   }
   
   func userInput(request: Game.UserInputAction.Request) {
      guard let currentUniverse = self.currentUniverse else { assertionFailure(); return }
      let location = request.location
      let viewSize = request.viewSize
      let dimensions = currentUniverse.dimensions
      let result = pointWorker.calculateIndexes(fromLocation: location, viewSize: viewSize, dimensions: dimensions)
      var cells = currentUniverse.cells
      cells[result.row][result.column] = !cells[result.row][result.column]
      let nextUniverse = Game.Model.Universe(cells: cells, dimensions: currentUniverse.dimensions)
      self.setAndPresentUniverse(nextUniverse)
   }
   
   private func scrollingToNextStep() {
      guard let universe = self.currentUniverse else { assertionFailure(); return }
      let nextUniverse = worker.calculateNextStep(fromUniverse: universe)
      self.setAndPresentUniverse(nextUniverse)
   }
   
   private func setAndPresentUniverse(_ nextUniverse: Game.Model.Universe) {
      let response = Game.DisplayLoop.Response(universe: nextUniverse)
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

