//
//  AuthenticationError.swift
//  UNES
//
//  Created by João Santos Sena on 12/07/23.
//

enum PortalAuthError : Error {
    case invalidCredentials
    case otherError(underlyingError: Error)
}
