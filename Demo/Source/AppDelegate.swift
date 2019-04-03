//
//  AppDelegate.swift
//  PinLayoutDemo
//
//  Created by Rene Pirringer on 02.01.17.
//  Copyright © 2017 org.openbakery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		if self.window == nil {
			let window = UIWindow(frame: UIScreen.main.bounds)
			window.rootViewController = ViewController()
			window.makeKeyAndVisible()
			self.window = window
		}
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}


}

