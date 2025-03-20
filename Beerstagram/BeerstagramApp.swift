//
//  BeerstagramApp.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

import SwiftUI
import SwiftData

@main
struct BeerstagramApp: App {
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			Item.self,
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		
		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
	
	var body: some Scene {
		WindowGroup {
			// TODO: - Inject
			StoriesView(
				viewModel: StoriesViewModel(
					storiesUseCase: StoriesUseCase(
						storiesStateRepository: StoriesStateRepository(),
						currentPageStateRepository: CurrentPageStateRepository()
					)
				)
			)
		}
		.modelContainer(sharedModelContainer)
	}
}
