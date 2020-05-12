//
//  UIViewController+System.swift
//  JXExtension
//
//  Created by JeromeXiong on 2018/5/11.
//  Copyright © 2018年 JeromeXiong. All rights reserved.
//

import UIKit
import AVKit
import AudioToolbox
import AVFoundation

/// fileprivate var jx_system = SystemProxy()
///
/// 包含
/// - 打开相册 openPhotoLibrary
/// - 打开相机 openCamera
/// - 保存图片 saveImage
/// - 播放视频 playVideo
/// - 二维码扫描 startScan

public class SystemProxy: NSObject {
    fileprivate var completed: ((_ image: UIImage) -> ())?
    fileprivate(set) var isEditor: Bool = false
    fileprivate var scanSession: AVCaptureSession?
    fileprivate var scanPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var saveCompleted: ((Bool)->Void)?
    fileprivate var scompleted: ((_ value: String?, _ error: NSError?) -> ())?
}
//MARK: - UIImagePickerControllerDelegate
extension SystemProxy: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    ///打开相册
    ///
    /// - Parameters:
    ///   - editor: 是否是编辑状态
    ///   - complete: image回调
    func openPhotoLibrary(editor: Bool, complete: @escaping (_ image: UIImage) -> ()) -> UIImagePickerController {
        completed = complete
        isEditor = editor
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .photoLibrary
        photo.allowsEditing = editor
        return photo
    }
    
    ///打开相机
    ///
    /// - Parameters:
    ///   - editor: 是否是编辑状态
    ///   - complete: image回调
    func openCamera(editor: Bool, complete: @escaping (_ image: UIImage) -> ()) -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("\(#file) - [\(#line)]: camera is invalid, please check")
            return nil
        }
        completed = complete
        isEditor = editor
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .camera
        photo.allowsEditing = editor
        return photo
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[isEditor ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true) {
            guard let completed = self.completed else { return }
            completed(image)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
extension SystemProxy {
    /// 保存图片
    func saveImage(_ image: UIImage, completed: ((Bool)->Void)? = nil) {
        saveCompleted = completed
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc fileprivate func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        saveCompleted?(error == nil)
    }
    /// 播放视频
    func playVideo(_ url: URL, target: UIViewController) {
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        target.present(controller, animated: true) {
            player.play()
        }
    }
    /// 截图视频封面
    func videoHandlePhoto(_ url: URL?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        // 截图的时候调整到正确的方向
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0,preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0,timescale: 0)
        
        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
/// 扫码容器视图
class ScanView: UIView {}
extension SystemProxy: AVCaptureMetadataOutputObjectsDelegate {
    /// 开始扫描
    func startScan(_ base: UIViewController, completed: @escaping ((_ value: String?, _ error: NSError?) -> ())) {
        scompleted = completed
        setupScanSession(base)
        if let scanSession = scanSession, !scanSession.isRunning {
            scanSession.startRunning()
        }
    }
    func stopScan() {
        scanSession?.stopRunning()
    }
    fileprivate func setupScanSession(_ base: UIViewController) {
        do {
            guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
                throw NSError(domain: "\(#file)", code: 404, userInfo: ["line": "[\(#line)]", "message": "camera is invalid, please check"])
            }
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            let scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(AVCaptureSession.Preset.high)
            if scanSession.canAddInput(input){
                scanSession.addInput(input)
            }
            if scanSession.canAddOutput(output){
                scanSession.addOutput(output)
            }
            output.metadataObjectTypes = [
                AVMetadataObject.ObjectType.qr,
                AVMetadataObject.ObjectType.code93,
                AVMetadataObject.ObjectType.code39,
                AVMetadataObject.ObjectType.code128,
                AVMetadataObject.ObjectType.code39Mod43,
                AVMetadataObject.ObjectType.ean13,
                AVMetadataObject.ObjectType.ean8
            ]
            
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session: scanSession)
            scanPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            switch UIApplication.shared.statusBarOrientation {
            case .portrait:
                scanPreviewLayer.connection?.videoOrientation = .portrait
            case .landscapeLeft:
                scanPreviewLayer.connection?.videoOrientation = .landscapeLeft
            case .landscapeRight:
                scanPreviewLayer.connection?.videoOrientation = .landscapeRight
            default:
                scanPreviewLayer.connection?.videoOrientation = .portrait
            }
            // 设置扫码容器
            self.scanPreviewLayer?.removeFromSuperlayer()
            var container = base.view!
            if let scan = base.view.subviews.first, scan is ScanView {
                container = scan
            }
            
            scanPreviewLayer.frame = container.bounds
            base.view.layer.insertSublayer(scanPreviewLayer, at: 0)
            
            self.scanPreviewLayer = scanPreviewLayer
            self.scanSession = scanSession
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                //设置扫描区域
                output.rectOfInterest = scanPreviewLayer.metadataOutputRectConverted(fromLayerRect: container.bounds)
            })
            
        } catch let error as NSError {
            print("errorInfo\(error.description)")
            scompleted?(nil, error)
        }
    }
    public func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count <= 0 { return }
        guard let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let qrString = resultObj.stringValue else {
            let error = NSError(domain: "\(#file)", code: 401, userInfo: ["line": "[\(#line)]", "message": "scan failed"])
            scompleted?(nil, error)
            return
        }
        scompleted?(qrString, nil)
    }
}
