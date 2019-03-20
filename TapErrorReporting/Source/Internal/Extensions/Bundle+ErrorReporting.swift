//
//  Bundle+ErrorReporting.swift
//  TapErrorReporting
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Bundle {
	
	internal static let errorReportingResources: Bundle = {
		
		guard let result = Bundle(for: ErrorReporter.self).tap_childBundle(named: Constants.errorReportingResourcesBundleName) else {
			
			fatalError("There is no \(Constants.errorReportingResourcesBundleName) bundle.")
		}
		
		return result
	}()
	
	private struct Constants {
		
		fileprivate static let errorReportingResourcesBundleName = "ErrorReportingResources"
		
		@available(*, unavailable) private init() {}
	}
}
