//
//  StoriesUseCase.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

import Combine
import Foundation

public protocol StoriesUseCaseProtocol {
	var publisher: AnyPublisher<[StoriesDomainModel], Never> { get }
	var current: [StoriesDomainModel] { get }

	func tapped(value: StoriesDomainModel)
	func fetchStories(for page: Int) async throws
}

public class StoriesUseCase: StoriesUseCaseProtocol {
	
	private let storiesStateRepository: StoriesStateRepositoryProtocol
	private let currentPageStateRepository: CurrentPageStateRepositoryProtocol

	public var publisher: AnyPublisher<[StoriesDomainModel], Never> {
		return storiesStateRepository.publisher
	}
	public var current: [StoriesDomainModel] {
		return storiesStateRepository.current
	}

	public init(
		storiesStateRepository: StoriesStateRepositoryProtocol,
		currentPageStateRepository: CurrentPageStateRepositoryProtocol
	) {
		self.storiesStateRepository = storiesStateRepository
		self.currentPageStateRepository = currentPageStateRepository
	}

	public func tapped(value: StoriesDomainModel) {
		storiesStateRepository.tapped(value: value)
	}

	public func fetchStories(for page: Int) async throws {
		let newStories: [StoriesDomainModel] = (1...5).map { storiesIndex in
			let user = UUID().uuidString
			let stories: [StoryDomainModel] = (1...5).compactMap { storyIndex in
				return getRandomStory()
			}

			return StoriesDomainModel(user: user, state: .new, stories: stories)
		}
		storiesStateRepository.add(values: newStories)
	}

	let users: [[String: Any]] = [
		["id": 1, "name": "Neo", "profile_picture_url": "https://i.pravatar.cc/300?u=1"],
		["id": 2, "name": "Trinity", "profile_picture_url": "https://i.pravatar.cc/300?u=2"],
		["id": 3, "name": "Morpheus", "profile_picture_url": "https://i.pravatar.cc/300?u=3"],
		["id": 4, "name": "Smith", "profile_picture_url": "https://i.pravatar.cc/300?u=4"],
		["id": 5, "name": "Oracle", "profile_picture_url": "https://i.pravatar.cc/300?u=5"],
		["id": 6, "name": "Cypher", "profile_picture_url": "https://i.pravatar.cc/300?u=6"],
		["id": 7, "name": "Niobe", "profile_picture_url": "https://i.pravatar.cc/300?u=7"],
		["id": 8, "name": "Dozer", "profile_picture_url": "https://i.pravatar.cc/300?u=8"],
		["id": 9, "name": "Switch", "profile_picture_url": "https://i.pravatar.cc/300?u=9"],
		["id": 10, "name": "Tank", "profile_picture_url": "https://i.pravatar.cc/300?u=10"],
		["id": 11, "name": "Seraph", "profile_picture_url": "https://i.pravatar.cc/300?u=11"],
		["id": 12, "name": "Sati", "profile_picture_url": "https://i.pravatar.cc/300?u=12"],
		["id": 13, "name": "Merovingian", "profile_picture_url": "https://i.pravatar.cc/300?u=13"],
		["id": 14, "name": "Persephone", "profile_picture_url": "https://i.pravatar.cc/300?u=14"],
		["id": 15, "name": "Ghost", "profile_picture_url": "https://i.pravatar.cc/300?u=15"],
		["id": 16, "name": "Lock", "profile_picture_url": "https://i.pravatar.cc/300?u=16"],
		["id": 17, "name": "Rama", "profile_picture_url": "https://i.pravatar.cc/300?u=17"],
		["id": 18, "name": "Bane", "profile_picture_url": "https://i.pravatar.cc/300?u=18"],
		["id": 19, "name": "The Keymaker", "profile_picture_url": "https://i.pravatar.cc/300?u=19"],
		["id": 20, "name": "Commander Thadeus", "profile_picture_url": "https://i.pravatar.cc/300?u=20"],
		["id": 21, "name": "Kid", "profile_picture_url": "https://i.pravatar.cc/300?u=21"],
		["id": 22, "name": "Zee", "profile_picture_url": "https://i.pravatar.cc/300?u=22"],
		["id": 23, "name": "Mifune", "profile_picture_url": "https://i.pravatar.cc/300?u=23"],
		["id": 24, "name": "Roland", "profile_picture_url": "https://i.pravatar.cc/300?u=24"],
		["id": 25, "name": "Cas", "profile_picture_url": "https://i.pravatar.cc/300?u=25"],
		["id": 26, "name": "Colt", "profile_picture_url": "https://i.pravatar.cc/300?u=26"],
		["id": 27, "name": "Vector", "profile_picture_url": "https://i.pravatar.cc/300?u=27"],
		["id": 28, "name": "Sequoia", "profile_picture_url": "https://i.pravatar.cc/300?u=28"],
		["id": 29, "name": "Sentinel", "profile_picture_url": "https://i.pravatar.cc/300?u=29"],
		["id": 30, "name": "Turing", "profile_picture_url": "https://i.pravatar.cc/300?u=30"]
	]

	func getRandomStory() -> StoryDomainModel? {
		if let randomUser = users.randomElement(),
		   let id = randomUser["id"] as? Int,
		   let name = randomUser["name"] as? String,
		   let profilePictureURL = randomUser["profile_picture_url"] as? String {
			
			return StoryDomainModel(user: name, image: profilePictureURL, state: .new)
		}
		return nil
	}
}
