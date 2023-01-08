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

        //View
        [SerializeField] private Dropdown _dropdown;

        private void Awake() {

            SetDropdownOption();

            _dropdown.onValueChanged.AddListener(val => 
            {
                _selfieSegmentationBarracudaTest.SetWebCamera(val);
            });
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