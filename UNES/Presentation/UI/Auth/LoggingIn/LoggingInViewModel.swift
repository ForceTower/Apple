//
//  LoggingInViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 11/07/23.
//

import Arcadia
import Foundation
import Combine
import Alamofire

class LoggingInViewModel {
    private let coordinator: AuthCoordinator
    private let loginUseCase: LoginUseCase
    private let username: String
    private let password: String
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private(set) var name: String? = nil
    @Published private(set) var progress: Float = 0.0
    
    var onLoginProgress: AnyPublisher<PortalAuthProgress, PortalAuthError> {
        _onLoginProgress.eraseToAnyPublisher()
    }
    private let _onLoginProgress = PassthroughSubject<PortalAuthProgress, PortalAuthError>()
    
    private var loginTask: Task<Void, Never>? = nil
    
    init(username: String, password: String, coordinator: AuthCoordinator, loginUseCase: LoginUseCase) {
        self.username = username
        self.password = password
        self.loginUseCase = loginUseCase
        self.coordinator = coordinator
    }
    
    func start() {
        PassthroughSubject.emittingValues(from: loginUseCase.execute(username: username, password: password))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch(completion) {
                case .finished:
                    self?._onLoginProgress.send(completion: .finished)
                case .failure(let error):
                    self?.onError(error: error)
                }
            } receiveValue: { [weak self] progress in
                switch(progress) {
                case .handshake:
                    self?.progress = 0.1
                case .fetchedUser(let person):
                    self?.name = person.name.localizedCapitalized
                    self?.progress = 0.3
                case .fetchedMessages:
                    self?.progress = 0.5
                case .fetchedSemesterInfo:
                    self?.progress = 0.7
                case .fetchedGrades:
                    self?.progress = 1
                }
                self?._onLoginProgress.send(progress)
            }.store(in: &subscriptions)
    }
    
    private func onError(error: Error) {
        if let error = error.asAFError, let code = error.responseCode {
            if code == 401 {
                _onLoginProgress.send(completion: .failure(.invalidCredentials))
                return
            }
        }
        _onLoginProgress.send(completion: .failure(.otherError(underlyingError: error)))
    }
    
    func onLoginCompleted() {
        coordinator.navigateToSignedIn()
    }
}
