//
//  LoginProgress.swift
//  UNES
//
//  Created by João Santos Sena on 12/07/23.
//

import Arcadia

enum PortalAuthProgress {
    case handshake
    case fetchedUser(person: Person)
    case fetchedMessages
    case fetchedSemesterInfo
    case fetchedGrades
}
