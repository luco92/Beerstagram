//
//  FeedViewModel.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

import Foundation
import Combine

public enum FeedState {
	case loading
	case loaded(viewData: [FeedViewData])
	case error(error: Error)
}

class FeedViewModel: ObservableObject {
	let selectedStories: StoriesDomainModel
	@Published var state: FeedState = .loading

	init(selectedStories: StoriesDomainModel) {
		self.selectedStories = selectedStories
	
		let viewData = selectedStories.stories.map {
			FeedViewData(id: UUID().uuidString, user: $0.user, image: $0.image, isSeen: $0.state.isSeen)
		}
		state = .loaded(viewData: viewData)
	}
}
