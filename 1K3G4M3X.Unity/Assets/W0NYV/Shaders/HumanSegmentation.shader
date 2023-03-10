Shader "Unlit/HumanSegmentation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("MaskTexture", 2D) = "white" {}

        _BPM ("BPM", float) = 120.0

        // Pixelate
        [Toggle(_USE_PIXELATE)]_UsePixelate("Use Pixelate", Float) = 0
        _MaxWidth_Pixelate ("MaxWidth_Pixelate", float) = 1920.0
        _MaxHeight_Pixelate ("MaxHeight_Pixelate", float) = 1080.0
        _MinWidth_Pixelate ("MinWidth_Pixelate", float) = 160.0
        _MinHeight_Pixelate ("MinHeight_Pixelate", float) = 90.0

        // BlockWave
        [Toggle(_USE_BLOCK_WAVE)]_UseBlockWave("Use Block Wave", Float) = 0
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

        // ConstantColor
        [Toggle(_USE_CONSTANT_COLOR)]_UseConstantColor("Use Constant Color", Float) = 0
        _R_ConstantColor ("R_ConstantColor", Range(0.0, 1.0)) = 1.0
        _G_ConstantColor ("G_ConstantColor", Range(0.0, 1.0)) = 1.0
        _B_ConstantColor ("B_ConstantColor", Range(0.0, 1.0)) = 1.0
        _Blend_ConstantColor ("Blend_ConstantColor", Range(0.0, 1.0)) = 1.0

        // Tile2
        [Toggle(_USE_TILE2)]_UseTile2("Use Tile 2", Float) = 0

        // Threshold
        _Threshold ("Threshold", Range(0.01, 1.0)) = 0.01
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

            #pragma multi_compile _ _USE_PIXELATE
            #pragma multi_compile _ _USE_HUMAN_WAVE
            #pragma multi_compile _ _USE_TILE
            #pragma multi_compile _ _USE_BLOCK_WAVE
            #pragma multi_compile _ _USE_CONSTANT_COLOR
            #pragma multi_compile _ _USE_TILE2

            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "./cginc/HumanWave.cginc"
            #include "./cginc/Tile.cginc"
            #include "./cginc/Pixelate.cginc"

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

            //Pixelate
            float _MaxWidth_Pixelate;
            float _MaxHeight_Pixelate;
            float _MinWidth_Pixelate;
            float _MinHeight_Pixelate;

            //BlockWave
            float _Segment_Wave;
            float _Gap_Wave;
            float _Amplitude_Wave;

            //HumanWave
            float _Speed_HumanWave;
            float _RotSpeed_HumanWave;
            float _Offset_HumanWave;
            float _Frequency_HumanWave;
            float _Amplitude_HumanWave;

            //ConstantColor
            float _R_ConstantColor;
            float _G_ConstantColor;
            float _B_ConstantColor;
            float _Blend_ConstantColor;

            //Threshold
            float _Threshold;

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

                //UV??????
                #if _USE_TILE2
                _uv = Tile2(t, _uv);
                #endif

                #if _USE_PIXELATE
                _uv = Pixelate(t, _uv, _MaxWidth_Pixelate, _MaxHeight_Pixelate, _MinWidth_Pixelate, _MinHeight_Pixelate);
                #endif

                #if _USE_BLOCK_WAVE
                _uv.x += sin(floor((i.uv.y*_Segment_Wave))/_Gap_Wave + t) * _Amplitude_Wave;
                #endif

                #if _USE_TILE
                if(TileAlpha(p, t).w > 3.9)
                {
                    _uv.y = (frac(_uv.y*4.0) / 4.0) + 0.375;
                }
                else
                {
                    _uv.x = (frac(_uv.x*4.0) / 4.0) + 0.375;
                }
                #endif

                // sample the texture
                fixed4 col = tex2D(_MainTex, _uv);
                fixed4 col2 = tex2D(_MaskTex, _uv);

                if(_Threshold != 0.01) col2.rgb = step(_Threshold, col2.rgb);

                //?????????
                #if _USE_HUMAN_WAVE
                col = HumanWave(_uv, t, _Speed_HumanWave, _RotSpeed_HumanWave, _Offset_HumanWave, _Frequency_HumanWave, _Amplitude_HumanWave);
                #endif

                #if _USE_CONSTANT_COLOR
                col = lerp(col, fixed4(_R_ConstantColor, _G_ConstantColor, _B_ConstantColor, 1.0), _Blend_ConstantColor);
                #endif

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                col.w = col2.x;

                #if _USE_TILE
                col = col * fixed4(TileAlpha(p, t).rgb, 1.0);
                #endif

                return col;
            }
            ENDCG
        }
    }
}
