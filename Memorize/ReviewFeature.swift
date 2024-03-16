import ComposableArchitecture

struct Card {
  var question: String
  var answer: String
}
struct UndoItem {}

@Reducer
struct ReviewFeature {
  @ObservableState
  struct State {
//    var isNormal = true
    var normalCards: [Card] = []
    var normalMissedCards: [Card] = []
    var startingNormalCount = 0
    var currentCard: Card? = nil
//    var reverseCards: [Card] = []
//    var undoStack: [UndoItem] = []
  }
  
  enum Action {
    case rightSwipe
    case leftSwipe
//    case undo
//    case addMoreNormal
//    case addMoreReverse
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .rightSwipe:
        print("correct")
        return .none
      case .leftSwipe:
        print("missed")
        return .none
      }
    }
  }
}
