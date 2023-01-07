using UnityEngine;
// Import SelfieSegmentationBarracuda package
using Mediapipe.SelfieSegmentation;
using UnityEngine.UI;

public class SelfieSegmentationBarracudaTest: MonoBehaviour
{
    // Set "Packages/SelfieSegmentationBarracuda/ResourceSet/SelfieSegmentationResource.asset" on the Unity Editor.
    [SerializeField] SelfieSegmentationResource resource;

    SelfieSegmentation segmentation;

    private static int INPUT_SIZE = 256;
    private static int FPS = 60;

    WebCamTexture webCamTexture;

    private MeshRenderer _meshRenderer;

    void Start(){

        TryGetComponent<MeshRenderer>(out _meshRenderer);

        segmentation = new SelfieSegmentation(resource);
        this.webCamTexture = new WebCamTexture(WebCamTexture.devices[2].name, 1280, 720, FPS);
        this.webCamTexture.Play();
    }

    void Update(){
        Texture input = webCamTexture; // Your input image texture

        // Predict segmentation by neural network model.
        segmentation.ProcessImage(input);
        // Segmentation results can be obtained with `SelfieSegmentation.texture`.
        Texture result = segmentation.texture;

        _meshRenderer.material.SetTexture("_MainTex", input);
        _meshRenderer.material.SetTexture("_MaskTex", result);
    }

    void OnApplicationQuit(){
        // Must call Dispose method when no longer in use.
        segmentation.Dispose();
    }
}