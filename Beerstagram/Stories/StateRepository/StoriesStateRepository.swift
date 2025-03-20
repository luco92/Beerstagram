//
//  StoriesStateRepository.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

import Combine

public protocol StoriesStateRepositoryProtocol {
	var publisher: AnyPublisher<[StoriesDomainModel], Never> { get }
	var current: [StoriesDomainModel] { get }

	func tapped(value: StoriesDomainModel)
	func add(value: StoriesDomainModel)
	func add(values: [StoriesDomainModel])
}

public final class StoriesStateRepository: StoriesStateRepositoryProtocol {

	private var subject: CurrentValueSubject<[StoriesDomainModel], Never> = CurrentValueSubject([])

	public var publisher: AnyPublisher<[StoriesDomainModel], Never> {
		return subject.eraseToAnyPublisher()
	}

	public var current: [StoriesDomainModel] {
		return subject.value
	}

	public init() {}

	public func tapped(value: StoriesDomainModel) {
		var domainModels = subject.value
		if let index = domainModels.firstIndex(where: { $0 == value }) {
			domainModels[index].state = .viewed
			subject.send(domainModels)
		}
	}

	public func add(value: StoriesDomainModel) {
		var domainModels = subject.value
		domainModels.append(value)
		subject.send(domainModels)
	}

	public func add(values: [StoriesDomainModel]) {
		var domainModels = subject.value
		domainModels.append(contentsOf: values)
		subject.send(domainModels)
	}
}
