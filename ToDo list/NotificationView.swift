import SwiftUI

struct NotificationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("New Notification")
                .font(.headline)
                .padding()
                .background(colorScheme == .dark ? Color.darkButtonColor : Color.lightButtonColor)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.top, 50) // Adjust padding to position the notification
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
