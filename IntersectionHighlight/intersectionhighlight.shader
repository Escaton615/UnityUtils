Shader "FXTest/intersectionhighlight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "gray" {}
		_HighlightThreshold ("Threshold", range(0.0, 0.3)) = 0.05
		//_CameraDepthTexture("Depth Tex", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "RenderQueue"="Transparent" }
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
				//float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				//float2 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(1)
				float4 projPos : TEXCOORD0;
				float4 vertex : SV_POSITION;
				//float2 depth : TEXCOORD1;
				
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _CameraDepthTexture;
			float _HighlightThreshold;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				//o.uv = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
				//COMPUTE_EYEDEPTH(o.depth);
				o.projPos = ComputeScreenPos(o.vertex);
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 col = Linear01Depth(tex2D(_CameraDepthTexture, float2(i.projPos.x/i.projPos.w, i.projPos.y / i.projPos.w)).r);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				float d = Linear01Depth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)).r);
				float z = Linear01Depth(i.vertex.z);
				float t = d;
				//return col;
				float diff = abs(d - z);
				float s = step(diff, _HighlightThreshold);
				//float s = diff;
				//return col;
				return s * fixed4(1, 1, 1, 0.5) + (1 - s) * fixed4(0.5, 0.5, 0.5, 0.5);

				//UNITY_OUTPUT_DEPTH(i.depth);
			}
			ENDCG
		}
	}
}
