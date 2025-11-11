Shader "Dithers/Dither_bayer16"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _Alpha("Alpha", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 screenPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.pos);
                return o;
            }

            fixed4 _Color;
            float _Alpha;

            static const int ditherMap[16] = {
                0, 8, 2, 10,
                12, 4, 14, 6,
                3, 11, 1, 9,
                15, 7, 13, 5
            };

            float Bayer16(float2 Pos)
            {
                return ditherMap[(int(Pos.x) % 4) + (int(Pos.y) % 4) * 4]/16.0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 screenPos = i.screenPos.xy / i.screenPos.w;
                screenPos *= _ScreenParams.xy;
                clip(Bayer16(screenPos) - (1-_Alpha));

                return _Color;
            }
            ENDCG
        }
    }
}
