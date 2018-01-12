Shader "Unlit/Dither"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DitherMap ("Texture", 2D) = "white" {}
		_Threshold ("Discard Threshold", Float) = 0.5
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
				float4 clippos:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D_float _DitherMap;
			float4 _DitherMap_ST;
			float _Threshold;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.clippos = o.vertex;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				float2 duv = i.clippos.xy/i.clippos.w + float2(0.5, 0.5);

				duv.x = duv.x *8;
				duv.y = duv.y *8;
				
				float dval = tex2D(_DitherMap, duv).r;
				float depth = LinearEyeDepth(i.clippos.z/i.clippos.w) - 0.3;
				clip(depth/_Threshold - dval);
				
				//col = fixed4(depth, depth, depth, 1);

				return col;
			}
			ENDCG
		}
	}
}
