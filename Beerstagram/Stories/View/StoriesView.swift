//
//  StoriesView.swift
//  Beerstagram
//
//  Created by Luc-Olivier Merson on 20/03/2025.
//

import SwiftUI

struct StoriesView: View {
	@StateObject var viewModel: StoriesViewModel
	@State private var showDetail = false

	var body: some View {
		NavigationStack {
			ZStack {
				Color.black.ignoresSafeArea()
				ContentView()
			}
			.navigationTitle("Stories")
			.navigationBarTitleDisplayMode(.inline)

		}
		.sheet(isPresented: $showDetail) {
			if let selectedStories = viewModel.selectedStories {
				FeedView(viewModel: FeedViewModel(selectedStories: selectedStories))
			}
		}
	}

	@ViewBuilder
	private func ContentView() -> some View {
		switch viewModel.state {
			case let .loaded(viewData):
				VStack {
					ScrollView(.horizontal, showsIndicators: false) {
						LazyHStack(spacing: 10) {
							ForEach(viewData.enumeratedArray(), id: \.offset) { index, viewData in
								StoriesItemView(viewData: viewData)
									.onAppear {
										viewModel.itemDidAppear(at: index)
									}
									.onTapGesture {
										viewModel.itemTapped(at: index)
										showDetail = true
									}
							}
						}
						.padding()
					}
					.frame(maxWidth: .infinity, maxHeight: 100)

					Spacer()
				}

			case let .error(error):
				Text(error.localizedDescription)

			case .loading:
				ProgressView()
		}
	}
}

struct StoriesItemView: View {
	var viewData: StoriesViewData

	var body: some View {
		VStack {
			ZStack {
				if let image = viewData.image {
					ZStack {
						AsyncImage(url: URL(string: image)) { image in
							image.resizable().scaledToFill()
						} placeholder: {
							ProgressView()
						}
						.ignoresSafeArea()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
					}
					.frame(height: 80)
					.clipShape(Circle())
					.overlay(
						Circle()
							.stroke(viewData.isSeen ? Color.gray : Color.blue, lineWidth: 3)
					)
				}
			}
			
			Text(viewData.user)
				.foregroundColor(.white)
				.font(.caption)
				.multilineTextAlignment(.center)
				.frame(height: 20)
		}
		.frame(width: 80)
	}
}

public extension Sequence {
	func enumeratedArray() -> [EnumeratedSequence<Self>.Element] {
		return Array(self.enumerated())
	}
}
