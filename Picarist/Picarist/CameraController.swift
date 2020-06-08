import SwiftUI
import AVFoundation

struct CustomCameraRepresentable: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Binding var didTapCapture: Bool
    @Binding var isCaptured: Bool
    
    func makeUIViewController(context: Context) -> CustomCameraController {
        let controller = CustomCameraController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {

        if(self.didTapCapture) {
            cameraViewController.didTapRecord()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CustomCameraRepresentable

        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            parent.didTapCapture = false
            parent.isCaptured = true
            if let imageData = photo.fileDataRepresentation() {
                parent.image = cropImage(originImage: UIImage(data: imageData)!)
            }
        }
        
        func cropImage(originImage: UIImage) -> UIImage {
            var newImage: UIImage?
            
            let cgimage = originImage.cgImage
            let imageSize: CGFloat = CGFloat(originImage.size.width)
            let posX: CGFloat = CGFloat(originImage.size.height / 4) - 60
            let posY: CGFloat = 0
            let cgwidth: CGFloat = imageSize
            let cgheight: CGFloat = imageSize
            
            
            let imageRef: CGImage = cgimage!.cropping(to: CGRect(x: posX, y: posY, width: cgwidth, height: cgheight))!
            
            newImage = UIImage(cgImage: imageRef, scale: originImage.scale, orientation: originImage.imageOrientation)
            return newImage!
        }
    }
}

class CustomCameraController: UIViewController {
    
    var image: UIImage?

    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    //DELEGATE
    var delegate: AVCapturePhotoCaptureDelegate?

    func didTapRecord() {

        let settings = AVCapturePhotoSettings()
        
        photoOutput?.capturePhoto(with: settings, delegate: delegate!)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
    }

    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                mediaType: AVMediaType.video,
                position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices {

            switch device.position {
                case AVCaptureDevice.Position.front:
                    self.frontCamera = device
                case AVCaptureDevice.Position.back:
                    self.backCamera = device
                default:
                    break
            }
        }

        self.currentCamera = self.backCamera
    }


    func setupInputOutput() {
        do {

            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)

        } catch {
            print(error)
        }

    }
    func setupPreviewLayer()
    {
        let sizeOffset: CGFloat = 0
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = CGRect(x: sizeOffset, y: sizeOffset, width: self.view.frame.width - sizeOffset * 2, height: self.view.frame.width - sizeOffset * 2)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)

    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}
