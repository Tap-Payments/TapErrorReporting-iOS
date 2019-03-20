//
//  ErrorReporterImpl.swift
//  TapErrorReporting
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapAdditionsKit.SeparateWindowRootViewController
import struct	TapAdditionsKit.TypeAlias
import class	TapApplication.TapApplicationPlistInfo
import class	TapBundleLocalization.LocalizationProvider
import struct	TapNetworkManager.TapBodyModel
import class	TapNetworkManager.TapNetworkManager
import class	TapNetworkManager.TapNetworkRequestOperation
import class	UIKit.UIAlertController.UIAlertAction
import class	UIKit.UIAlertController.UIAlertController
import class	UIKit.UIDevice.UIDevice

internal final class ErrorReporterImpl: ErrorReporting {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var language: String {
		
		get {
			
			return self.localizationProvider.selectedLanguage
		}
		set {
			
			self.localizationProvider.selectedLanguage = newValue
		}
	}
	
	internal var canReport: Bool {
		
		return !UserDefaults.standard.bool(forKey: Constants.errorReportingForbiddenKey)
	}
	
	// MARK: Methods
	
	internal func report(_ error: Encodable, in product: String, productVersion: String, alertOrientationHandler: PermissionAlertOrientationHandler) {
		
		self.askUserPermissionToReport(alertOrientationHandler) { [weak self] (granted) in
			
			guard granted else { return }
			
			self?.reportError(error, in: product, version: productVersion, orientationHandler: alertOrientationHandler)
		}
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let canAutoSendReportKey			= Constants.userDefaultsPrefix + ".can_send_report_automatically"
		fileprivate static let errorReportingForbiddenKey	= Constants.userDefaultsPrefix + ".error_reporting_forbidden"
		
		fileprivate static let reportErrorAPIPath			= "reportError"
		fileprivate static let region						= "europe-west1"
		fileprivate static let projectID					= "tap-error-reporting"
		fileprivate static let baseURL						= URL(string: "https://\(Constants.region)-\(Constants.projectID).cloudfunctions.net/")!

		fileprivate static let productKey			= "product"
		fileprivate static let productVersionKey	= "version"
		fileprivate static let osKey				= "os"
		fileprivate static let osVersionKey			= "os_version"
		fileprivate static let bundleIDKey			= "bundle_id"
		fileprivate static let timeKey				= "time"
		fileprivate static let dataKey				= "data"
		
		private static let userDefaultsPrefix = "company.tap.error_reporting"
		
		@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
	}
	
	// MARK: Properties
	
	private lazy var localizationProvider	= LocalizationProvider(bundle: .errorReportingResources)
	private lazy var networkManager: TapNetworkManager			= {
		
		let manager = TapNetworkManager(baseURL: Constants.baseURL)
		manager.isRequestLoggingEnabled = true
		
		return manager
	}()
	
	private lazy var dateFormatter = DateFormatter()
	
	private lazy var applicationMetadata: [String: Any] = [
	
		Constants.osKey:		UIDevice.current.systemName,
		Constants.osVersionKey:	UIDevice.current.systemVersion,
		Constants.bundleIDKey:	TapApplicationPlistInfo.shared.bundleIdentifier ?? "nil",
		Constants.timeKey:		self.currentDateString
	]
	
	private var currentDateString: String {
		
		return self.dateFormatter.string(from: Date())
	}
	
	// MARK: Methods
	
	private func askUserPermissionToReport(_ alertOrientationHandler: PermissionAlertOrientationHandler, _ grantedClosure: @escaping (Bool) -> Void) {
		
		if UserDefaults.standard.bool(forKey: Constants.errorReportingForbiddenKey) {
			
			grantedClosure(false)
			return
		}
		
		if UserDefaults.standard.bool(forKey: Constants.canAutoSendReportKey) {
			
			grantedClosure(true)
			return
		}
		
		let title = self.localizationProvider.localizedString(for: .alert_report_error_title)
		let message = self.localizationProvider.localizedString(for: .alert_report_error_message)
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let dontAllowAction = UIAlertAction(title: self.localizationProvider.localizedString(for: .alert_report_error_btn_dont_allow), style: .cancel) { [weak self, weak alert] (action) in
			
			if let nonnullAlert = alert, let nonnullSelf = self {
				
				nonnullSelf.hide(nonnullAlert) {
					
					grantedClosure(false)
				}
			}
			else {
				
				grantedClosure(false)
			}
		}
		
		let allowAction = UIAlertAction(title: self.localizationProvider.localizedString(for: .alert_report_error_btn_allow), style: .default) { [weak self, weak alert] (action) in
			
			if let nonnullAlert = alert, let nonnullSelf = self {
				
				nonnullSelf.hide(nonnullAlert) {
					
					grantedClosure(true)
				}
			}
			else {
				
				grantedClosure(true)
			}
		}
		
		alert.addAction(dontAllowAction)
		alert.addAction(allowAction)
		
		self.show(alert, orientationHandler: alertOrientationHandler)
	}
	
	private func reportError(_ error: Encodable, in product: String, version: String, orientationHandler: PermissionAlertOrientationHandler) {
		
		var data = self.applicationMetadata
		
		data[Constants.timeKey]				= self.currentDateString
		data[Constants.productKey]			= product
		data[Constants.productVersionKey]	= version
		
		let errorDictionary = (try? error.tap_asDictionary()) ?? [:]
		data[Constants.dataKey] = errorDictionary
		
		let body = TapBodyModel(body: data)
		let operation = TapNetworkRequestOperation(path: Constants.reportErrorAPIPath, method: .POST, headers: nil, urlModel: nil, bodyModel: body, responseType: .json)
		self.networkManager.performRequest(operation) { [weak self] (dataTask, response, error) in
			
			if let nonnullError = error {
				
				print("Error: \(nonnullError)")
			}
			else {
				
				self?.showSuccessAlert(orientationHandler)
			}
		}
	}
	
	private func showSuccessAlert(_ handler: PermissionAlertOrientationHandler) {
		
		let title = self.localizationProvider.localizedString(for: .alert_report_error_success_title)
		let message = self.localizationProvider.localizedString(for: .alert_report_error_success_message)
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let dismissTitle = self.localizationProvider.localizedString(for: .alert_report_error_success_btn_dismiss)
		let dismissAction = UIAlertAction(title: dismissTitle, style: .default) { [weak self, weak alert] (action) in
			
			if let nonnullAlert = alert, let nonnullSelf = self {
				
				nonnullSelf.hide(nonnullAlert)
			}
		}
		
		alert.addAction(dismissAction)
		
		self.show(alert, orientationHandler: handler)
	}
	
	private func show(_ alert: UIAlertController, orientationHandler: PermissionAlertOrientationHandler) {
		
		let appearanceClosure: TypeAlias.GenericViewControllerClosure<SeparateWindowRootViewController> = { rootController in
			
			let supportedOrientations	= orientationHandler.supportedInterfaceOrientations(for: rootController)
			let canAutorotate			= orientationHandler.viewControllerShouldAutorotate(rootController)
			let preferredOrientation	= orientationHandler.preferredInterfaceOrientationForPresentation(of: rootController)
			
			rootController.canAutorotate					= canAutorotate
			rootController.allowedInterfaceOrientations		= supportedOrientations
			rootController.preferredInterfaceOrientation	= preferredOrientation
			
			rootController.present(alert, animated: true, completion: nil)
		}
		
		DispatchQueue.main.async {
			
			alert.tap_showOnSeparateWindow(below: .statusBar, using: appearanceClosure)
		}
	}
	
	internal func hide(_ alert: UIAlertController, completion: TypeAlias.ArgumentlessClosure? = nil) {
		
		DispatchQueue.main.async {
			
			alert.tap_dismissFromSeparateWindow(true, completion: completion)
		}
	}
}
