import SwiftUI

struct ContentView: View {
    @State private var showingCustomCamera = false
    @State private var inputImage: UIImage?
    @State private var isCaptured = false
    
    var body: some View {
        NavigationView{
            CustomCameraPhotoView(showingCustomCamera: $showingCustomCamera, inputImage: $inputImage, isCaptured: $isCaptured)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
