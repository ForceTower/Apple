//
//  SubscribeToTopicUseCase.swift
//  UNES
//
//  Created by João Santos Sena on 02/08/23.
//

import Foundation
import Firebase

class SubscribeToTopicUseCase {
    func execute(topics: [String]) {
        let messaging = Messaging.messaging()
        topics.forEach { topic in
            messaging.subscribe(toTopic: topic)
        }
    }
}
