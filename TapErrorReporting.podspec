TapAdditionsKitDependencyVersion		= '>= 1.3.3' unless defined? TapAdditionsKitDependencyVersion
TapAlertViewControllerDependencyVersion	= '>= 1.0.2' unless defined? TapAlertViewControllerDependencyVersion
TapApplicationDependencyVersion			= '>= 1.0.7' unless defined? TapApplicationDependencyVersion
TapBundleLocalizationDependencyVersion	= '>= 1.0.3' unless defined? TapBundleLocalizationDependencyVersion
TapNetworkManagerDependencyVersion		= '>= 1.2.6' unless defined? TapNetworkManagerDependencyVersion
TapNibViewDependencyVersion				= '>= 1.0.4' unless defined? TapNibViewDependencyVersion

Pod::Spec.new do |tapErrorReporting|
    
    tapErrorReporting.platform				= :ios
    tapErrorReporting.ios.deployment_target	= '8.0'
    tapErrorReporting.swift_versions		= ['4.0', '4.2', '5.0']
    tapErrorReporting.name					= 'TapErrorReporting'
    tapErrorReporting.summary				= 'Tap error reporting library'
    tapErrorReporting.requires_arc			= true
    tapErrorReporting.version				= '1.0.3'
    tapErrorReporting.license				= { :type => 'MIT', :file => 'LICENSE' }
    tapErrorReporting.author				= { 'Tap Payments' => 'hello@tap.company' }
    tapErrorReporting.homepage				= 'https://github.com/Tap-Payments/TapErrorReporting-iOS'
    tapErrorReporting.source				= { :git => 'https://github.com/Tap-Payments/TapErrorReporting-iOS.git', :tag => tapErrorReporting.version.to_s }
	tapErrorReporting.source_files			= 'TapErrorReporting/Source/**/*.{swift}'
	tapErrorReporting.ios.resource_bundle	= { 'ErrorReportingResources' => ['TapErrorReporting/Resources/*.{xib}', 'TapErrorReporting/Resources/Localization/*.lproj'] }
	
	tapErrorReporting.dependency	'TapAdditionsKit/Foundation/Bundle',				TapAdditionsKitDependencyVersion
	tapErrorReporting.dependency	'TapAdditionsKit/SwiftStandartLibrary/Dictionary',	TapAdditionsKitDependencyVersion
	tapErrorReporting.dependency	'TapAdditionsKit/SwiftStandartLibrary/Encodable',	TapAdditionsKitDependencyVersion
	tapErrorReporting.dependency	'TapAdditionsKit/Tap/ClassProtocol',				TapAdditionsKitDependencyVersion
	tapErrorReporting.dependency	'TapAdditionsKit/Tap/TypeAlias',					TapAdditionsKitDependencyVersion
	tapErrorReporting.dependency	'TapAlertViewController',							TapAlertViewControllerDependencyVersion
	tapErrorReporting.dependency	'TapApplication',									TapApplicationDependencyVersion
	tapErrorReporting.dependency	'TapBundleLocalization',							TapBundleLocalizationDependencyVersion
	tapErrorReporting.dependency	'TapNetworkManager/Core',							TapNetworkManagerDependencyVersion
	tapErrorReporting.dependency	'TapNibView',										TapNibViewDependencyVersion
	
end
