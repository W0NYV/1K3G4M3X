Shader "CustomPostProcess/Tile"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BPM ("BPM", float) = 120.0
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

            fixed4 frag (v2f i) : SV_Target
            {
                float t = _Time.y * _BPM / 60.0;


                float2 _uv = i.uv;
                float2 p = (_uv - 0.5) * 2.0;

                p.x += 0.75;
                _uv.x += 0.25;

                float l = step(length(p.x), 1.0/4.0);
                
                fixed4 col = tex2D(_MainTex, _uv);
                //fixed4 col = fixed4(_uv.x, _uv.y, 1.0, 1.0) * fixed4(l, l, l, 1.0);
                //fixed4 col = fixed4(l, l, l, 1.0);

                return col;
            }
            ENDCG
        }
    }
}
