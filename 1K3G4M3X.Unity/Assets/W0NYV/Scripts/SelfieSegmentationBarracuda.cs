using UnityEngine;
// Import SelfieSegmentationBarracuda package
using Mediapipe.SelfieSegmentation;
using UnityEngine.UI;

namespace W0NYV.IkegameX
{
    public class SelfieSegmentationBarracuda: MonoBehaviour
    {
        // Set "Packages/SelfieSegmentationBarracuda/ResourceSet/SelfieSegmentationResource.asset" on the Unity Editor.
        [SerializeField] SelfieSegmentationResource resource;

        SelfieSegmentation segmentation;

        private static int INPUT_SIZE = 256;
        private static int FPS = 60;

        WebCamTexture webCamTexture;

        private MeshRenderer _meshRenderer;

        public void SetWebCamera(int val)
        {
            if(webCamTexture != null)
            {
                webCamTexture.Stop();
            }
            webCamTexture = new WebCamTexture(WebCamTexture.devices[val].name, 1280, 720, FPS);
            webCamTexture.Play();
        }

        void Start(){

            TryGetComponent<MeshRenderer>(out _meshRenderer);

            segmentation = new SelfieSegmentation(resource);
        }

        void Update(){

            if(webCamTexture == null) return;

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
}