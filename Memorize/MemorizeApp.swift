import SwiftUI
import ComposableArchitecture

@main
struct MemorizeApp: App {
  static let store = Store(initialState: ReviewFeature.State()) {
    ReviewFeature()
      ._printChanges()
  }
  var body: some Scene {
    WindowGroup {
      ReviewView(store: MemorizeApp.store)
    }
  }
}
