Shader "FXTest/intersectionhighlight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "gray" {}
		_HighlightThreshold ("Threshold", float) = 0.05
		_Strength ("Highlight Strength", float) = 2
		//_CameraDepthTexture("Depth Tex", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100

		Pass
		{
			ZWrite Off
			Cull Off
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
				float2 uv : TEXCOORD2;
				//UNITY_FOG_COORDS(1)
				float4 projPos : TEXCOORD0;
				float4 vertex : SV_POSITION;
				//float2 depth : TEXCOORD1;
				
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _CameraDepthTexture;
			float _HighlightThreshold;
			float _Strength;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.vertex.xy, _MainTex);
				//COMPUTE_EYEDEPTH(o.depth);
				o.projPos = ComputeScreenPos(o.vertex);
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				float d = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)).r);
				float z = LinearEyeDepth(i.vertex.z);

				float diff = abs(d - z);
				//float s = step(diff, _HighlightThreshold);
				float s = saturate(1-diff/_HighlightThreshold);

				return s * col * _Strength + (1-s) * col;

			}
			ENDCG
		}
	}
}
