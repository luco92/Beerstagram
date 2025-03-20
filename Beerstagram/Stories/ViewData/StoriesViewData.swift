//
//  StoriesViewData.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

public struct StoriesViewData: Identifiable {
	public var id: String
	var user: String
	var image: String?
	var isSeen: Bool

	public init(id: String, user: String, image: String?, isSeen: Bool) {
		self.id = id
		self.user = user
		self.image = image
		self.isSeen = isSeen
	}
}
