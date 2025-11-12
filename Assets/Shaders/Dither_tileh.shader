Shader "Dithers/Dither_tileH"
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

            static const uint ditherMap[49] = {
                0,5,4,1,2,3,6,
                1,2,3,6,0,5,4,
                6,0,5,4,1,2,3,
                4,1,2,3,6,0,5,
                3,6,0,5,4,1,2,
                5,4,1,2,3,6,0,
                2,3,6,0,5,4,1,
            };

            float Pulse9Int(float2 Pos)
            {
                uint2 p = uint2(Pos);
                return ditherMap[(p.x % 7) + (p.y % 7) * 7]/7.0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 screenPos = i.screenPos.xy / i.screenPos.w;
                screenPos *= _ScreenParams.xy;
                clip(Pulse9Int(screenPos) - (1-_Alpha));

                return _Color;
            }
            ENDCG
        }
    }
}
