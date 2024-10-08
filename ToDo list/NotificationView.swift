import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack {
            Text("New Notification")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
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
