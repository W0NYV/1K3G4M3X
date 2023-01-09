using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace W0NYV.IkegameX
{
    public class CameraFilter : MonoBehaviour
    {

        [SerializeField] private Material _filter;
        public Material Filter
        {
            get => _filter;
        }

        private void OnRenderImage(RenderTexture src, RenderTexture dest) {
            Graphics.Blit(src, dest, _filter);
        }
    }
}
