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
        [SerializeField] private SelfieSegmentationBarracudaTest _selfieSegmentationBarracudaTest;
        [SerializeField] CameraFilter _cameraFilter;
        [SerializeField] MeshRenderer _quad;
        private CalcTempo _calcTempo;

        //View
        [SerializeField] private Dropdown _dropdown;
        [SerializeField] private Button _tempoButton;
        [SerializeField] private Text _tempoText;
        
        [SerializeField] private Toggle _pixelateToggle;
        [SerializeField] private Toggle _blockWaveToggle;

        private void Awake() {

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

            _pixelateToggle.onValueChanged.AddListener(val => 
            {
                _cameraFilter.enabled = val;
            });

            _blockWaveToggle.onValueChanged.AddListener(val =>
            {
                if(val)
                {
                    _quad.material.SetFloat("_IsOn_Wave", 1.0f);
                }
                else
                {
                    _quad.material.SetFloat("_IsOn_Wave", 0.0f);
                }
            });

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