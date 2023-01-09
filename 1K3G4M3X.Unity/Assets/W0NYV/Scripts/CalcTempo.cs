using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace W0NYV.IkegameX
{
    public class CalcTempo
    {

        private float t = 0f;
        private float BPM = 120.0f;
        private float[] intervalArray = {0.5f, 0.5f, 0.5f, 0.5f};
        private int count = 0;
        private float preTime = 0f;

        public void SetElement()
        {
            count++;
            if(count >= intervalArray.Length)
            {
                count = 0;
            }

            intervalArray[count] = Time.time - preTime;

            preTime = Time.time;
        }

        public void Calculate()
        {
            float sum = 0.0f;

            foreach (var value in intervalArray)
            {
                sum += value;
            }

            float ave = sum / (float)intervalArray.Length;

            BPM = 60/ave;
        }

        public float GetBPM()
        {
            return BPM;
        }
    }
}
