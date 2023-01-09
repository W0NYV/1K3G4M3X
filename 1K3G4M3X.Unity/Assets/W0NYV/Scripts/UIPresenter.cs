using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace W0NYV.IkegameX
{
    public class UIPresenter : MonoBehaviour
    {

        //Model
        private CalcTempo _calcTempo;

        [SerializeField] private CameraFilter _cameraFilter;

        [SerializeField] private GameObject _quad;
        private MeshRenderer _meshRenderer;
        private SelfieSegmentationBarracudaTest _selfieSegmentationBarracudaTest;
        
        //View
        [SerializeField] private Dropdown _dropdown;

        [Header("Tempo")]
        [SerializeField] private Button _tempoButton;
        [SerializeField] private Text _tempoText;

        [Header("Pixelate")]
        [SerializeField] private Toggle _pixelateToggle;
        
        [Header("BlockWave")]
        [SerializeField] private Toggle _blockWaveToggle;
        [SerializeField] private Slider _blockWaveSlider_Segment;
        [SerializeField] private Slider _blockWaveSlider_Gap;
        [SerializeField] private Slider _blockWaveSlider_Amplitude;

        private void Awake() {

            GetComponentToQuad();

            //誰がnewする問題, Extenject~~~
            _calcTempo = new CalcTempo();

            SetDropdownOption();

            _dropdown.onValueChanged.AddListener(val => 
            {
                _selfieSegmentationBarracudaTest.SetWebCamera(val);
            });

            _tempoButton.onClick.AddListener(() => 
            {
                _calcTempo.SetElement();
                _calcTempo.Calculate();
                _tempoText.text = "TEMPO: " + _calcTempo.GetBPM().ToString("0.00");

                _cameraFilter.Filter.SetFloat("_BPM", _calcTempo.GetBPM());
            });

            #region Pixelate
            _pixelateToggle.onValueChanged.AddListener(val => 
            {
                _cameraFilter.enabled = val;
            });
            #endregion

            #region BlockWave
            _blockWaveToggle.onValueChanged.AddListener(val =>
            {
                if(val)
                {
                    _meshRenderer.material.SetFloat("_IsOn_Wave", 1.0f);
                }
                else
                {
                    _meshRenderer.material.SetFloat("_IsOn_Wave", 0.0f);
                }
            });

            _blockWaveSlider_Segment.onValueChanged.AddListener(val =>
            {
                float value = val * 49f + 1f;
                _meshRenderer.material.SetFloat("_Segment_Wave", value);
            });

            _blockWaveSlider_Gap.onValueChanged.AddListener(val =>
            {
                float value = val * 9f + 1f;
                _meshRenderer.material.SetFloat("_Gap_Wave", value);
            });

            _blockWaveSlider_Amplitude.onValueChanged.AddListener(val =>
            {
                _meshRenderer.material.SetFloat("_Amplitude_Wave", val);
            });

            #endregion

        }

        private void GetComponentToQuad()
        {
            _quad.TryGetComponent<MeshRenderer>(out _meshRenderer);
            _quad.TryGetComponent<SelfieSegmentationBarracudaTest>(out _selfieSegmentationBarracudaTest);
        }

        //本当はdropdownが持っておくべき
        private void SetDropdownOption()
        {
            foreach (var device in WebCamTexture.devices)
            {
                _dropdown.AddOptions(new List<string> {device.name});
            }

            if(WebCamTexture.devices.Length != 0) _selfieSegmentationBarracudaTest.SetWebCamera(0);
        }
    }
}