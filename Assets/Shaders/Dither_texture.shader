Shader "Dithers/Texture"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _DitherTex ("Dither Texture", 2D) = "white" {}
        _UvScale ("UV Scale", Vector) = (3,3,0,0)
        _Alpha("Alpha", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            HLSLPROGRAM
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
                float4 screenPos : TEXCOORD0;
            };

            float4 _Color;
            sampler2D _DitherTex;
            float4 _DitherTex_TexelSize;
            float4 _UvScale;
            float _Alpha;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.pos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 screenPos = i.screenPos.xy / i.screenPos.w;

                float screenAspect = _ScreenParams.x / _ScreenParams.y;
                float texAspect = _DitherTex_TexelSize.z / _DitherTex_TexelSize.w;
                float2 scale = 1.0;
                scale.x = (screenAspect > texAspect)? screenAspect / texAspect : 1.0;
                scale.y = (screenAspect < texAspect)? texAspect / screenAspect : 1.0;

                fixed2 uv = (screenPos - 0.5) * scale + 0.5;
                uv = frac(uv * _UvScale.xy);
                fixed4 col = tex2D(_DitherTex, uv);

                clip(col.x - (1 - _Alpha));

                return _Color;
            }
            ENDHLSL
        }
    }
}
