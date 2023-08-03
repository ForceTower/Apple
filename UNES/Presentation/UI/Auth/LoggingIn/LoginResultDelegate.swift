//
//  LoginResultDelegate.swift
//  UNES
//
//  Created by João Santos Sena on 03/08/23.
//

import Foundation

protocol LoginResultDelegate {
    func didFailToLogin(withError error: PortalAuthError)
}
