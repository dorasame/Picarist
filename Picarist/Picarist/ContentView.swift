import SwiftUI

struct ContentView: View {
    
    @State private var image: Image?
    @State private var showingCustomCamera = false
    @State private var inputImage: UIImage?
    @State private var isCaptured = false
    
    var body: some View {
        NavigationView{
            CustomCameraPhotoView(image: $image, showingCustomCamera: $showingCustomCamera, inputImage: $inputImage, isCaptured: $isCaptured)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
