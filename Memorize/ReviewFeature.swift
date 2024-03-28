import ComposableArchitecture
import SwiftUI
import Tagged

struct Card: Equatable, Identifiable {
  var id: Tagged<Self, UUID>
  var question: String
  var answer: String
}
private struct UndoItem {
  var card: Card
  var correct: Bool
}

@Reducer
struct ReviewFeature {
  @ObservableState
  struct State {
    private let defaultText = "No cards left to review"
    private var isNormal = true
    var cards: IdentifiedArrayOf<Card> = []
    var missedCards: IdentifiedArrayOf<Card> = []
    var currentCard: Card? = nil
    fileprivate var undoStack: [UndoItem] = []
    var front: String {
        isNormal ? currentCard?.question ?? defaultText : currentCard?.answer.removingLeadingNumbers ?? defaultText
    }
    var back: String {
        isNormal ? currentCard?.answer ?? defaultText : currentCard?.question ?? defaultText
    }
    
    init(cards: [Card] = []) {
      self.cards = IdentifiedArray(uniqueElements: cards)
    }
  }
  
  enum Action {
    case rightSwipe
    case leftSwipe
    case onAppear
    case undo
    case delegate(Delegate)
    enum Delegate {
      case correct(card: Card)
      case missed(card: Card)
      case undo(card: Card, correct: Bool)
    }

//    case addMoreNormal
//    case addMoreReverse
  }
  
  @Dependency(\.withRandomNumberGenerator) var withRandomNumberGenerator
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        getNextRandomCard(state: &state)
        return .none
        
      case .rightSwipe:
        guard let currentCard = state.currentCard else { return .none }
        state.cards.remove(currentCard)
        state.undoStack.append(UndoItem(card: currentCard, correct: true))
        getNextRandomCard(state: &state)
        return .send(.delegate(.correct(card: currentCard)))
        
      case .leftSwipe:
        guard let currentCard = state.currentCard else { return .none }
        state.cards.remove(currentCard)
        state.missedCards.append(currentCard)
        state.undoStack.append(UndoItem(card: currentCard, correct: false))
        getNextRandomCard(state: &state)
        return .send(.delegate(.missed(card: currentCard)))
        
      case .undo:
        print("undo")
        guard let undoItem = state.undoStack.popLast() else { return .none }
        state.currentCard = undoItem.card
        state.cards.append(undoItem.card)
        state.missedCards.remove(undoItem.card)
        return .send(.delegate(.undo(card: undoItem.card, correct: undoItem.correct)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  private func getNextRandomCard(state: inout State) {
    let lastCard = state.currentCard
    if state.cards.isEmpty {
      state.cards = state.missedCards
      state.missedCards = []
    }
    
    if state.cards.count <= 1 {
      state.currentCard = state.cards.first
    } else {
      var nextCard: Card?
      repeat {
        nextCard = withRandomNumberGenerator {
          state.cards.randomElement(using: &$0)
        }
      } while nextCard == lastCard
      state.currentCard = nextCard
    }
  }
  
  static var mock: State {
    @Dependency(\.uuid) var uuid
    let state = State(
      cards: [
        Card(id: Card.ID(uuid()), question: "Hi", answer: "There"),
        Card(id: Card.ID(uuid()), question: "Hello", answer: "Hola")
      ]
    )
    return state
  }
}

struct ReviewView: View {
  let store: StoreOf<ReviewFeature>
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      CardView(front: store.front, back: store.back, isNormal: true)
        .clipShape(Rectangle())
        .gesture(DragGesture(minimumDistance: 40, coordinateSpace: .global)
          .onEnded { value in
            if value.translation.width > 20 {
              store.send(.rightSwipe)
            } else if value.translation.width < -20 {
              store.send(.leftSwipe)
            }
          })
      Button {
        store.send(.undo)
      } label: {
        Image(systemName: "arrow.uturn.backward.circle.fill")
          .font(.title)
      }
      .disabled(store.undoStack.isEmpty)
      .padding(.vertical)
      .padding(.trailing, 32)
    }
    .onAppear() {
      store.send(.onAppear)
    }
    
  }
}

#Preview {
  ReviewView(store: Store(initialState: ReviewFeature.mock) {
    ReviewFeature()
  })
}
