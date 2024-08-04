Shader "Hidden/RenaSAdditionalBlending"
{
    Properties
    {
        _DistTex ("DistTexture", 2D) = "white" {}
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        LOD 100
        Cull Off
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_local_fragment RenaSAdditionalBlending_LinearLightShine RenaSAdditionalBlending_MaskAlphaOverride

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            sampler2D _DistTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }


            float4 LiniearToGamma(float4 col)
            {
                return float4(LinearToGammaSpaceExact(col.r), LinearToGammaSpaceExact(col.g), LinearToGammaSpaceExact(col.b), (col.a));
            }
            float4 GammaToLinear(float4 col)
            {
                return float4(GammaToLinearSpaceExact(col.r), GammaToLinearSpaceExact(col.g), GammaToLinearSpaceExact(col.b), (col.a));
            }
            float4 AlphaBlending(float4 BaseColor,float4 AddColor,float3 BlendColor)
            {
                float BlendRatio = AddColor.a * BaseColor.a;
                float AddRatio = (1 - BaseColor.a) * AddColor.a;
                float BaseRatio = (1 - AddColor.a) * BaseColor.a;
                float Alpha = BlendRatio + AddRatio + BaseRatio;

                float3 ResultColor = (BlendColor * BlendRatio) + (AddColor.rgb * AddRatio) + (BaseColor.rgb * BaseRatio);
                ResultColor /= Alpha;
                
                return Alpha != 0 ? float4(ResultColor, Alpha) : float4(0, 0, 0, 0);
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 BaseColor = LiniearToGamma(tex2Dlod(_DistTex,float4( i.uv,0,0)));
                float4 AddColor = LiniearToGamma(tex2Dlod(_MainTex ,float4(i.uv,0,0)));
                float3 Bcol = BaseColor.rgb;
                float3 Acol = AddColor.rgb;
                float3 BlendColor = float3(0,0,0);

                #if RenaSAdditionalBlending_LinearLightShine
                BlendColor = Bcol + 2.0 * Acol - 1.0;
                #elif RenaSAdditionalBlending_MaskAlphaOverride
                return GammaToLinear(float4(Bcol, 1 - AddColor.a));
                #endif


                return GammaToLinear(AlphaBlending( BaseColor , AddColor , BlendColor));
            }
            ENDHLSL
        }
    }
}
