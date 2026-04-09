//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by Bee Wijaya on 08/04/26.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        makeShieldConfiguration()
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        makeShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        makeShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        makeShieldConfiguration()
    }
    
    private func makeShieldConfiguration() -> ShieldConfiguration {
        // UIKit implementation
        /**
         for the UI of the shield configuration and able to customize the words
         but not able to customize the design
         */
        ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: UIColor(named: "Secondary"),
            icon: UIImage(systemName: "lock.fill"),
            title: ShieldConfiguration.Label(
                text: "App Locked",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "Focus! Without Focus, you can't finished your task",
                color: UIColor.lightGray
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "OK",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor(named: "Primary"),
        )
    }

}
