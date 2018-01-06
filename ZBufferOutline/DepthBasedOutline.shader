Shader "CQ/DepthBasedOutline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineColor("Outline", Color) = (1,1,1,1)
		_OutlineThreshold("Outline depth diff threshold", Range(0,1)) = 0.01
		_DeltaX("pixel unit x", Float) = 0.01
		_DeltaY("pixel unit y", Float) = 0.01
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
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D_float _CameraDepthTexture;
			fixed4 _OutlineColor;
			float _OutlineThreshold;
			float _DeltaX;
			float _DeltaY;

			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col = tex2D(_MainTex, i.uv);
#if SHADER_API_D3D11
				i.uv = float2(i.uv.x, 1 - i.uv.y);
#endif
				float d = tex2D(_CameraDepthTexture, i.uv).r;
				float d1 = tex2D(_CameraDepthTexture, i.uv + float2(0, _DeltaY)).r;
				float d2 = tex2D(_CameraDepthTexture, i.uv + float2(0, -_DeltaY)).r;

				/*uncomment if 8 samples wanted*/
				//float d3 = tex2D(_CameraDepthTexture, i.uv + float2(_DeltaX, _DeltaY)).r;
				//float d4 = tex2D(_CameraDepthTexture, i.uv + float2(-_DeltaX, -_DeltaY)).r;
				//float d5 = tex2D(_CameraDepthTexture, i.uv + float2(-_DeltaX, _DeltaY)).r;
				//float d6 = tex2D(_CameraDepthTexture, i.uv + float2(_DeltaX, -_DeltaY)).r;

				float d7 = tex2D(_CameraDepthTexture, i.uv + float2(_DeltaX, 0)).r;
				float d8 = tex2D(_CameraDepthTexture, i.uv + float2(-_DeltaX, 0)).r;

				float diff1 = abs(d1-d);
				float diff2 = abs(d2-d);

				/*uncomment if 8 samples wanted*/
				/*
				float diff3 = abs(d3 - d);
				float diff4 = abs(d4 - d);
				float diff5 = abs(d5 - d);
				float diff6 = abs(d6 - d);
				*/
				
				float diff7 = abs(d7-d);
				float diff8 = abs(d8-d);

				/* swap if 8 samples wanted*/
				//float mdiff = max(max(max(diff1, diff2), max(diff3, diff4)), max(max(diff5, diff6), max(diff7, diff8)));
				float mdiff = max(max(diff1, diff2), max(diff7, diff8));
				
				float isoutline = step(_OutlineThreshold, mdiff);
				//mix
				col = isoutline * _OutlineColor + (1-isoutline) * col;
				return col;
			}
			ENDCG
		}
	}
}
