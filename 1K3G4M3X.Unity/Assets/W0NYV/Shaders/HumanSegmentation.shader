Shader "Unlit/HumanSegmentation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("MaskTexture", 2D) = "white" {}

        _BPM ("BPM", float) = 120.0

        // BlockWave
        _IsOn_Wave ("IsOn_Wave", float) = 0.0
        _Segment_Wave ("Segment_Wave", Range(1.0, 50.0)) = 20.0
        _Gap_Wave ("Gap_Wave", Range(1.0, 10.0)) = 2.0
        _Amplitude_Wave ("Amplitude_Wave", Range(0.0, 1.0)) = 0.1

        // HumanWave
        [Toggle(_USE_HUMAN_WAVE)]_UseHumanWave("Use Human Wave", Float) = 0
        _Speed_HumanWave ("Speed_HumanWave", Range(0.1, 0.4)) = 0.1
        _RotSpeed_HumanWave ("RotSpeed_HumanWave", Range(0.0, 0.2)) = 0.0625
        _Offset_HumanWave ("Offset_HumanWave", Range(0.0, 1.6)) = 0.05
        _Frequency_HumanWave ("Frequency_HumanWave", Range(0.1, 1.0)) = 0.25
        _Amplitude_HumanWave ("Amplitude_HumanWave", Range(0.01, 0.1)) = 0.05

        // Tile
        _IsOn_Tile ("IsOn_Tile", float) = 0.0
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ _USE_HUMAN_WAVE

            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "./cginc/HumanWave.cginc"
            #include "./cginc/TileAlpha.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _MaskTex;

            float _BPM;

            //BlockWave
            float _Segment_Wave;
            float _Gap_Wave;
            float _Amplitude_Wave;
            float _IsOn_Wave;

            //HumanWave
            float _Speed_HumanWave;
            float _RotSpeed_HumanWave;
            float _Offset_HumanWave;
            float _Frequency_HumanWave;
            float _Amplitude_HumanWave;

            //Tile
            float _IsOn_Tile;

            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float2x2 Rot(float r)
            {
                return float2x2(cos(r), -sin(r), sin(r), cos(r));
            }

            fixed4 frag (v2f i) : SV_Target
            {

                float t = _Time.y * _BPM / 60.0;

                float2 _uv = i.uv;
                float2 p = (_uv - 0.5) * 2.0;

                //UV関連
                _uv.x += _IsOn_Wave == 1.0 ? sin(floor((i.uv.y*_Segment_Wave))/_Gap_Wave + t) * _Amplitude_Wave : 0.0;
                
                if(_IsOn_Tile == 1)
                {
                    if(TileAlpha(p, t).w > 3.9)
                    {
                        _uv.y = (frac(_uv.y*4.0) / 4.0) + 0.375;
                    }
                    else
                    {
                        _uv.x = (frac(_uv.x*4.0) / 4.0) + 0.375;
                    }
                }

                // sample the texture
                fixed4 col = tex2D(_MainTex, _uv);
                fixed4 col2 = tex2D(_MaskTex, _uv);

                //色関連
                #if _USE_HUMAN_WAVE
                col = HumanWave(_uv, t, _Speed_HumanWave, _RotSpeed_HumanWave, _Offset_HumanWave, _Frequency_HumanWave, _Amplitude_HumanWave);
                #endif

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                col.w = col2.x;

                col = _IsOn_Tile == 1.0 ? col * fixed4(TileAlpha(p, t).rgb, 1.0) : col;

                return col;
            }
            ENDCG
        }
    }
}
