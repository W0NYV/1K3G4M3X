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

        [SerializeField] private GameObject _quad;
        private MeshRenderer _meshRenderer;
        private SelfieSegmentationBarracudaTest _selfieSegmentationBarracudaTest;
        
        //View
        [SerializeField] private Dropdown _dropdown;

        [Header("Tempo")]
        [SerializeField] private Klak.VJUI.Button _tempoButton;
        [SerializeField] private Text _tempoText;

        [Header("Pixelate")]
        [SerializeField] private Klak.VJUI.Toggle _pixelateToggle;
        
        [Header("BlockWave")]
        [SerializeField] private Klak.VJUI.Toggle _blockWaveToggle;
        [SerializeField] private Klak.VJUI.Knob _blockWaveKnob_Segment;
        [SerializeField] private Klak.VJUI.Knob _blockWaveKnob_Gap;
        [SerializeField] private Klak.VJUI.Knob _blockWaveKnob_Amplitude;

        [Header("HumanWave")]
        [SerializeField] private Klak.VJUI.Toggle _humanWaveToggle;
        [SerializeField] private Klak.VJUI.Knob _humanWaveKnob_Speed;
        [SerializeField] private Klak.VJUI.Knob _humanWaveKnob_RotSpeed;
        [SerializeField] private Klak.VJUI.Knob _humanWaveKnob_Offset;
        [SerializeField] private Klak.VJUI.Knob _humanWaveKnob_Frequency;
        [SerializeField] private Klak.VJUI.Knob _humanWaveKnob_Amplitude;

        [Header("Tile")]
        [SerializeField] private Klak.VJUI.Toggle _TileToggle;

        private void Awake() {

            GetComponentToQuad();

            //誰がnewする問題, Extenject~~~
            _calcTempo = new CalcTempo();

            InitShaderProperty();
            SetDropdownOption();

            _dropdown.onValueChanged.AddListener(val => 
            {
                _selfieSegmentationBarracudaTest.SetWebCamera(val);
            });

            _tempoButton.onButtonDown.AddListener(() => 
            {
                _calcTempo.SetElement();
                _calcTempo.Calculate();
                _tempoText.text = "TEMPO: " + _calcTempo.GetBPM().ToString("0.00");
                _meshRenderer.material.SetFloat("_BPM", _calcTempo.GetBPM());

            });

            #region Pixelate
            _pixelateToggle.onValueChanged.AddListener(val => 
            {
                if(val)
                {
                    _meshRenderer.material.EnableKeyword("_USE_PIXELATE");
                }
                else
                {
                    _meshRenderer.material.DisableKeyword("_USE_PIXELATE");
                }
            });
            #endregion

            #region BlockWave
            _blockWaveToggle.onValueChanged.AddListener(val =>
            {
                if(val)
                {
                    _meshRenderer.material.EnableKeyword("_USE_BLOCK_WAVE");
                }
                else
                {
                    _meshRenderer.material.DisableKeyword("_USE_BLOCK_WAVE");
                }
            });

            _blockWaveKnob_Segment.onValueChanged.AddListener(val =>
            {
                float value = val * 49f + 1f;
                _meshRenderer.material.SetFloat("_Segment_Wave", value);
            });

            _blockWaveKnob_Gap.onValueChanged.AddListener(val =>
            {
                float value = val * 9f + 1f;
                _meshRenderer.material.SetFloat("_Gap_Wave", value);
            });

            _blockWaveKnob_Amplitude.onValueChanged.AddListener(val =>
            {
                _meshRenderer.material.SetFloat("_Amplitude_Wave", val * 0.3f);
            });

            #endregion

            #region HumanWave
            _humanWaveToggle.onValueChanged.AddListener(val =>
            {
                if(val)
                {
                    _meshRenderer.material.EnableKeyword("_USE_HUMAN_WAVE");
                }
                else
                {
                    _meshRenderer.material.DisableKeyword("_USE_HUMAN_WAVE");
                }
            });

            _humanWaveKnob_Speed.onValueChanged.AddListener(val =>
            {
                float value = val * 0.3f + 0.1f;
                _meshRenderer.material.SetFloat("_Speed_HumanWave", value);
            });

            _humanWaveKnob_RotSpeed.onValueChanged.AddListener(val =>
            {
                float value = val * 0.2f;
                _meshRenderer.material.SetFloat("_RotSpeed_HumanWave", value);
            });

            _humanWaveKnob_Offset.onValueChanged.AddListener(val =>
            {
                float value = val * 1.6f;
                _meshRenderer.material.SetFloat("_Offset_HumanWave", value);
            });

            _humanWaveKnob_Frequency.onValueChanged.AddListener(val =>
            {
                float value = val * 0.9f + 0.1f;
                _meshRenderer.material.SetFloat("_Frequency_HumanWave", value);
            });

            _humanWaveKnob_Amplitude.onValueChanged.AddListener(val =>
            {
                float value = val * 0.09f + 0.01f;
                _meshRenderer.material.SetFloat("_Amplitude_HumanWave", value);
            });

            #endregion

            #region  Tile
            _TileToggle.onValueChanged.AddListener(val => 
            {
                if(val)
                {
                    _meshRenderer.material.EnableKeyword("_USE_TILE");
                }
                else
                {
                    _meshRenderer.material.DisableKeyword("_USE_TILE");
                }
            });
            #endregion

        }

        private void GetComponentToQuad()
        {
            _quad.TryGetComponent<MeshRenderer>(out _meshRenderer);
            _quad.TryGetComponent<SelfieSegmentationBarracudaTest>(out _selfieSegmentationBarracudaTest);
        }

        //本当はUIPresenterに書きたくない

        private void InitShaderProperty()
        {            
            
            _meshRenderer.material.SetFloat("_BPM", 120.0f);

            //BlockWave
            _meshRenderer.material.SetFloat("_Segment_Wave", 1.0f);
            _meshRenderer.material.SetFloat("_Gap_Wave", 1.0f);
            _meshRenderer.material.SetFloat("_Amplitude_Wave", 0.0f);

            //HumanWave
            _meshRenderer.material.SetFloat("_Speed_HumanWave", 0.1f);
            _meshRenderer.material.SetFloat("_RotSpeed_HumanWave", 0.0f);
            _meshRenderer.material.SetFloat("_Offset_HumanWave", 0.0f);
            _meshRenderer.material.SetFloat("_Frequency_HumanWave", 0.1f);
            _meshRenderer.material.SetFloat("_Amplitude_HumanWave", 0.01f);
        }

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