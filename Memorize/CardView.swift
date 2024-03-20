import SwiftUI

struct CardView: View {
  let front: String
  let back: String
  let isNormal: Bool
  @State private var isShowingFront = true
  
  var body: some View {
    ZStack {
      textView(text: front)
      .opacity(isShowingFront ? 1 : 0)
      textView(text: back)
      .opacity(isShowingFront ? 0 : 1)
    }
    .padding()
    .onTapGesture {
      withAnimation {
        isShowingFront.toggle()
      }
    }
  }
  
  func textView(text: String) -> some View {
    ScrollView {
      ZStack {
        Spacer().containerRelativeFrame([.horizontal, .vertical])
        
        VStack {
          Text(text)
            .font(.title)
        }
      }
    }
    .scrollBounceBehavior(.basedOnSize)
  }
}

#Preview {
  CardView(front: "Hi there", back: "Well hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\nWell hello, it's nice to see you today. This is something that's quite a bit longer.\n\n", isNormal: true)
}
