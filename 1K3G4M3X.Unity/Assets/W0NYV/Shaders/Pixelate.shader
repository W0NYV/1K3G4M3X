Shader "CustomPostProcess/Pixelate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BPM ("BPM", float) = 120.0

        _MaxWidth_Pixelate ("MaxWidth_Pixelate", float) = 1920.0
        _MaxHeight_Pixelate ("MaxHeight_Pixelate", float) = 1080.0
        _MinWidth_Pixelate ("MinWidth_Pixelate", float) = 160.0
        _MinHeight_Pixelate ("MinHeight_Pixelate", float) = 90.0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _BPM;

            float _MaxWidth_Pixelate;
            float _MaxHeight_Pixelate;
            float _MinWidth_Pixelate;
            float _MinHeight_Pixelate;

            fixed4 frag (v2f i) : SV_Target
            {

                float t = _Time.y * _BPM / 60.0;

                float pixelateTime = sin((frac(-t) * acos(-1.0)) / 2.0);

                float2 grid;
                grid.x = floor(i.uv.x * lerp(_MaxWidth_Pixelate, _MinWidth_Pixelate, pixelateTime)) / lerp(_MaxWidth_Pixelate, _MinWidth_Pixelate, pixelateTime);
                grid.y = floor(i.uv.y * lerp(_MaxHeight_Pixelate, _MinHeight_Pixelate, pixelateTime)) / lerp(_MaxHeight_Pixelate, _MinHeight_Pixelate, pixelateTime);


                fixed4 col = tex2D(_MainTex, grid);

                return col;
            }
            ENDCG
        }
    }
}
