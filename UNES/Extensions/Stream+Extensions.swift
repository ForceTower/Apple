//
//  Stream+Extensions.swift
//  UNES
//
//  Created by João Santos Sena on 12/07/23.
//

import Combine

extension PassthroughSubject where Failure == Error {
    static func emittingValues<T: AsyncSequence>(
        from sequence: T
    ) -> Self where T.Element == Output {
        let subject = Self()
        
        Task {
            do {
                for try await value in sequence {
                    subject.send(value)
                }
                
                subject.send(completion: .finished)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        
        return subject
    }
}
