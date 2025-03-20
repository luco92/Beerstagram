//
//  ContentView.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

import SwiftUI
import SwiftData

struct FeedView: View {
	@State private var currentIndex = 0
	@State private var isLoaded = false

	@StateObject private var viewModel: FeedViewModel

	init(viewModel: FeedViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	var body: some View {
		ZStack {
			Color.black.ignoresSafeArea()
			ContentView()
		}
	}

	@ViewBuilder
	private func ContentView() -> some View {
		switch viewModel.state {
			case let .loaded(viewData):
				TabView(selection: $currentIndex) {
					ForEach(viewData.enumeratedArray(), id: \.offset) { index, viewData in
						ZStack {
							if let image = viewData.image {
								AsyncImage(url: URL(string: image)) { phase in
									if let image = phase.image {
										image
											.resizable()
											.scaledToFill()
											.opacity(isLoaded ? 1.0 : 0.0)
											.animation(.easeInOut(duration: 0.5), value: isLoaded)
											.onAppear {
												isLoaded = true
											}
									} else if phase.error != nil {
										Color.gray
									} else {
										ProgressView()
									}
								}
							}
						}.onTapGesture {
							// ViewModel load next feeds
						}
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .automatic))
				.scrollTargetBehavior(.paging)

			case let .error(error):
				Text(error.localizedDescription)

			case .loading:
				ProgressView()
		}
	}
}
