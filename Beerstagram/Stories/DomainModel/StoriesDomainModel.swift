//
//  StoriesDomainModel.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

public struct StoryDomainModel: Equatable {
	var user: String
	var image: String
	var state: StoriesState
}

public struct StoriesDomainModel: Equatable {
	var user: String
	var state: StoriesState
	var stories: [StoryDomainModel]
	var currentIndex: Int

	public init(user: String, state: StoriesState, stories: [StoryDomainModel]) {
		self.user = user
		self.state = state
		self.stories = stories
		self.currentIndex = 0
	}
}
