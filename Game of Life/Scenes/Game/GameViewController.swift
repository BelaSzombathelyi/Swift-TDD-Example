import UIKit

protocol GameDisplayLogic: class {
   func displayUniverse(viewModel: Game.ViewModel)
}

class GameViewController: BaseViewController, GameDisplayLogic {
   
   var interactor: GameBusinessLogic?
   
   // MARK: Setup
   
   override func setup() {
      super.setup()
      let dimensions = Game.Dimensions(width: 20, height: 40)
      let universe = Game.Universe(dimensions: dimensions)
      let viewController = self
      let interactor = GameInteractor()
      let presenter = GamePresenter()
      viewController.interactor = interactor
      interactor.presenter = presenter
      interactor.currentUniverse = universe
      presenter.viewController = viewController
   }
   
   // MARK: View lifecycle
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      interactor?.start(request: Game.StartRequest(stepTimeInterval: 0.3))
   }

   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      interactor?.stop()
   }
   
   @IBOutlet weak var gameView: GameView!
   
   // MARK: Rotation support

   override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      coordinator.animate(alongsideTransition: { _ in
      }, completion: { _ in
         guard let dataStore = self.interactor as? GameDataStore else { assertionFailure(); return }
         guard let universe = dataStore.currentUniverse else { assertionFailure(); return }
         self.updateDisplayedUniverse(withDimensions: universe.dimensions)
      })
      super.viewWillTransition(to: size, with: coordinator)
   }
   
   func updateDisplayedUniverse(withDimensions dimensions: Game.Dimensions) {
      gameView.update(byDimensions: dimensions)
   }
   
   // MARK: GameDisplayLogic
   
   func displayUniverse(viewModel: Game.ViewModel) {
      gameView.display(universe: viewModel.universe)
      updateDisplayedUniverse(withDimensions: viewModel.universe.dimensions)
   }
}

