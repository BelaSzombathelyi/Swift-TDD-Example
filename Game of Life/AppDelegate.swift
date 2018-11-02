//
//  AppDelegate.swift
//  Game of Life
//
//  Created by Béla Szomathelyi on 2018. 11. 01..
//  Copyright © 2018. Béla Szomathelyi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.rootViewController = GameViewController()
		self.window?.makeKeyAndVisible()
		return true
	}

}

