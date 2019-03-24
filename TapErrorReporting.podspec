Pod::Spec.new do |tapErrorReporting|
    
    tapErrorReporting.platform				= :ios
    tapErrorReporting.ios.deployment_target	= '8.0'
    tapErrorReporting.swift_version			= '4.2'
    tapErrorReporting.name					= 'TapErrorReporting'
    tapErrorReporting.summary				= 'Tap error reporting library'
    tapErrorReporting.requires_arc			= true
    tapErrorReporting.version				= '1.0.1'
    tapErrorReporting.license				= { :type => 'MIT', :file => 'LICENSE' }
    tapErrorReporting.author				= { 'Tap Payments' => 'hello@tap.company' }
    tapErrorReporting.homepage				= 'https://github.com/Tap-Payments/TapErrorReporting-iOS'
    tapErrorReporting.source				= { :git => 'https://github.com/Tap-Payments/TapErrorReporting-iOS.git', :tag => tapErrorReporting.version.to_s }
	tapErrorReporting.source_files			= 'TapErrorReporting/Source/**/*.{swift}'
	tapErrorReporting.ios.resource_bundle	= { 'ErrorReportingResources' => ['TapErrorReporting/Resources/*.{xib}', 'TapErrorReporting/Resources/Localization/*.lproj'] }
	
	tapErrorReporting.dependency	'TapAdditionsKit/Foundation/Bundle'
	tapErrorReporting.dependency	'TapAdditionsKit/SwiftStandartLibrary/Dictionary'
	tapErrorReporting.dependency	'TapAdditionsKit/SwiftStandartLibrary/Encodable'
	tapErrorReporting.dependency	'TapAdditionsKit/Tap/ClassProtocol'
	tapErrorReporting.dependency	'TapAdditionsKit/Tap/TypeAlias'
	tapErrorReporting.dependency	'TapAlertViewController'
	tapErrorReporting.dependency	'TapApplication'
	tapErrorReporting.dependency	'TapBundleLocalization'
	tapErrorReporting.dependency	'TapNetworkManager/Core'
	tapErrorReporting.dependency	'TapNibView'
	
end
