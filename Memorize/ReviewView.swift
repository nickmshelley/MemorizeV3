import SwiftUI
import ComposableArchitecture

struct ReviewView: View {
  let store: StoreOf<ReviewFeature>
  
  var body: some View {
    VStack {
      Text("Qeustion")
      Text("Answer")
    }
    .clipShape(Rectangle())
    .gesture(DragGesture(minimumDistance: 40, coordinateSpace: .global)
      .onEnded { value in
        if value.translation.width > 20 {
          store.send(.rightSwipe)
        } else if value.translation.width < -20 {
          store.send(.leftSwipe)
        }
      })
  }
}

#Preview {
  ReviewView(store: Store(initialState: ReviewFeature.State()) {
    ReviewFeature()
  })
}
