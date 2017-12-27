//TODO: c# script determining if camera intersects with decal box
Shader "CQ/Decal"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "gray" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+10" }
		LOD 100
		ZTest Off
		ZWrite Off
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
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
				float4 vertex : SV_POSITION;
				float4 scrpos : TEXCOORD0;
				float3 viewspace : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.viewspace = UnityObjectToViewPos(v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.scrpos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// screen position to depth tex uv
				float2 duv = i.scrpos.xy / i.scrpos.w;
				duv = float2((1 + duv.x) / 2, (1 - duv.y) / 2);

				// fetch depth
				float3 viewRay = i.viewspace.xyz / i.viewspace.z;
				float d = LinearEyeDepth(tex2D(_CameraDepthTexture, duv));

				//get on screen buffer world position
				float3 viewPos = viewRay * d;
				float4 worldpos = mul(unity_CameraToWorld, float4(-viewPos.x, -viewPos.y, viewPos.z, 1));		
				
				//transform to decal projector obj space to check clip
				float3 objpos = mul(unity_WorldToObject, worldpos);
				clip(0.5 - abs(objpos.xyz));

				//not clipped: sample texture based on object position
				float2 uv = objpos.xy + 0.5;
				fixed4 col = tex2D(_MainTex, uv * _MainTex_ST.xy + _MainTex_ST.zw );

				return col;
			}
			ENDCG
		}
	}
}
