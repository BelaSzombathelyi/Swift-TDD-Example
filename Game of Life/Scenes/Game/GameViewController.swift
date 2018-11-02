import UIKit

protocol GameDisplayLogic: class {
   func displayNextUniverse(viewModel: Game.ViewModel)
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
   
   override func viewDidLoad() {
      super.viewDidLoad()
      interactor?.start(stepTimeInterval: 0.3)
   }
   
   // MARK: Scrolling to next step
   
   @IBOutlet weak var gameView: GameView!
   
   func displayNextUniverse(viewModel: Game.ViewModel) {
      gameView.display(universe: viewModel.universe)
   }
}

