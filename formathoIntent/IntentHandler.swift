//
//  IntentHandler.swift
//  formathoIntent
//
//  Created by Luiz Carlos Maia Junior on 19/12/22.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    func resolveWitID(for intent: ConfigurationIntent, with completion: @escaping (ConfigurationWitIDResolutionResult) -> Void) {
        
        let witID = 181586
        
        let result: ConfigurationWitIDResolutionResult = ConfigurationWitIDResolutionResult.success(with: witID)
        
        completion(result)
    }
    
    func provideWitIDOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping
                                       (INObjectCollection<NSNumber>?, Error?) -> Void) {
        
        let collection = INObjectCollection(items: [intent.witID ?? NSNumber(0) ])
        
        completion(collection, nil)
    }
    
    /*func resolveWitID(for intent: ConfigurationIntent) async -> ConfigurationWitIDResolutionResult {
        <#code#>
    }*/
        
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}
