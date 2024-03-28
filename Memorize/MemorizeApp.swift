import SwiftUI
import ComposableArchitecture

@main
struct MemorizeApp: App {
  static let store = Store(initialState: ReviewFeature.mock) {
    ReviewFeature()
      ._printChanges()
  }
  var body: some Scene {
    WindowGroup {
      ReviewView(store: MemorizeApp.store)
    }
  }
}
