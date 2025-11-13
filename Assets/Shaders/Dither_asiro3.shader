Shader "Dithers/Dither_asiro3"
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

            static const uint ditherMap[36] = {
                0, 1, 2, 6, 3, 0,
                3, 4, 5, 7, 4, 1,
                6, 7, 8, 8, 5, 2,
                2, 5, 8, 8, 7, 6,
                1, 4, 7, 5, 4, 3,
                0, 3, 6, 2, 1, 0
            };

            float Asiro3(float2 Pos)
            {
                return ditherMap[(uint(Pos.x) % 6) + (uint(Pos.y) % 6) * 6]/9.0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 screenPos = i.screenPos.xy / i.screenPos.w;
                screenPos *= _ScreenParams.xy;
                clip(Asiro3(screenPos) - (1-_Alpha));

                return _Color;
            }
            ENDCG
        }
    }
}
