//
//  CurrentPageStateRepository.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

import Combine

public protocol CurrentPageStateRepositoryProtocol {
	var publisher: AnyPublisher<Int, Never> { get }
	var current: Int { get }
}

public final class CurrentPageStateRepository: CurrentPageStateRepositoryProtocol {
	private var subject: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)

	public var publisher: AnyPublisher<Int, Never> {
		return subject.eraseToAnyPublisher()
	}

	public var current: Int {
		return subject.value
	}
}
