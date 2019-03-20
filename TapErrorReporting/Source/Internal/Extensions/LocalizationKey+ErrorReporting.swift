//
//  LocalizationKey+ErrorReporting.swift
//  TapErrorReporting
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey

internal extension LocalizationKey {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal static let alert_report_error_title			= LocalizationKey("alert_report_error_title")
	internal static let alert_report_error_message			= LocalizationKey("alert_report_error_message")
	internal static let alert_report_error_dont_ask_again	= LocalizationKey("alert_report_error_dont_ask_again")
	internal static let alert_report_error_btn_allow		= LocalizationKey("alert_report_error_btn_allow")
	internal static let alert_report_error_btn_dont_allow	= LocalizationKey("alert_report_error_btn_dont_allow")
	
	internal static let alert_report_error_success_title		= LocalizationKey("alert_report_error_success_title")
	internal static let alert_report_error_success_message		= LocalizationKey("alert_report_error_success_message")
	internal static let alert_report_error_success_btn_dismiss	= LocalizationKey("alert_report_error_success_btn_dismiss")
}
