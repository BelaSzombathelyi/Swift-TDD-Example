import Quick
import Nimble
@testable import Game_of_Life

class ExampleBaseViewController: BaseViewController {
   static var didSetupBlock: () -> () = { }
   
   override func setup() {
      super.setup()
      ExampleBaseViewController.didSetupBlock()
   }
}

class BaseViewControllerSpec: QuickSpec {
   
   override func spec() {
      let archiver = NSKeyedArchiver(requiringSecureCoding: false)
      archiver.encode(ExampleBaseViewController())

      describe(".setup() method called once from") {
         var didSetupBlockCalled = 0
         ExampleBaseViewController.didSetupBlock = {
            didSetupBlockCalled += 1
         }
         beforeEach {
            didSetupBlockCalled = 0
         }
         it("init(coder:)") {
            let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: archiver.encodedData)
            let _ = ExampleBaseViewController(coder: unarchiver)
            expect(didSetupBlockCalled == 1).toEventually(beTrue())
         }
         it("init(nibName:bundle:)") {
            let _ = ExampleBaseViewController(nibName: nil, bundle: nil)
            expect(didSetupBlockCalled == 1).toEventually(beTrue())
         }
      }
   }
}
