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
        private CalcTempo _calcTempo;

        //View
        [SerializeField] private Dropdown _dropdown;
        [SerializeField] private Button _tempoButton;
        [SerializeField] private Text _tempoText;

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