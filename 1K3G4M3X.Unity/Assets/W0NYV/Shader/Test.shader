Shader "Unlit/Test"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("MaskTexture", 2D) = "white" {}

        _IsOn_Wave ("IsOn_Wave", float) = 0.0
        _Segment_Wave ("Segment_Wave", Range(1.0, 50.0)) = 20.0
        _Gap_Wave ("Gap_Wave", Range(1.0, 10.0)) = 2.0
        _Amplitude_Wave ("Amplitude_Wave", Range(0.0, 1.0)) = 0.1
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

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

            float _Segment_Wave;
            float _Gap_Wave;
            float _Amplitude_Wave;
            float _IsOn_Wave;

            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                float t = _Time.y * 120.0 / 60.0;


                float2 newUV = i.uv;

                newUV.x += _IsOn_Wave == 1.0 ? sin(floor((i.uv.y*_Segment_Wave))/_Gap_Wave + t) * _Amplitude_Wave : 0.0;

                // sample the texture
                fixed4 col = tex2D(_MainTex, newUV);
                fixed4 col2 = tex2D(_MaskTex, newUV);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                col.w = col2.x;

                return col;
            }
            ENDCG
        }
    }
}
