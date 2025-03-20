//
//  StoriesViewModel.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

import Foundation
import Combine

public enum StoriesState {
	case new
	case viewed

	public var isSeen: Bool {
		return self == .viewed
	}
}

public enum StoriesViewDataState {
	case loading
	case loaded(viewData: [StoriesViewData])
	case error(error: Error)
}

class StoriesViewModel: ObservableObject {
	@Published var state: StoriesViewDataState = .loading
	@Published var selectedStories: StoriesDomainModel? = nil

	private var currentPage = 0
	private let totalPages = 5
	@Published var isLoadingNextPage: Bool = false

	private let storiesUseCase: StoriesUseCaseProtocol

	private var cancellables: Set<AnyCancellable> = Set()

	init(storiesUseCase: StoriesUseCaseProtocol) {
		self.storiesUseCase = storiesUseCase
		setupCombine()
		fetchMoreStories()
	}

	public func fetchMoreStories() {
		Task { @MainActor [weak self] in
			do {
				guard let self else { return }
				try await storiesUseCase.fetchStories(for: currentPage)
				currentPage += 1
			} catch {
				self?.state = .error(error: error)
			}
		}
	}

	//@MainActor
	public func itemDidAppear(at index: Int) {
		if index >= totalPages - 2 {
			isLoadingNextPage = true
			fetchMoreStories()
			isLoadingNextPage = false

		}
	}

	@MainActor
	public func itemTapped(at index: Int) {
		let stories = storiesUseCase.current[index]
		storiesUseCase.tapped(value: stories)
		selectedStories = stories
	}

	private func setupCombine() {
		storiesUseCase.publisher.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] stories in
				let viewData = stories.map {
					StoriesViewData(
						id: UUID().uuidString,
						user: $0.user,
						image: $0.stories.first?.image,
						isSeen: $0.state.isSeen
					)
				}
				self?.state = .loaded(viewData: viewData)
			})
			.store(in: &cancellables)
	}
}
