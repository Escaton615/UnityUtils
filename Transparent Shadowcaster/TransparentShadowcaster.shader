Shader "CQ/TransparentShadowcaster" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
}

SubShader {
	Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100
	

	// Pass to render object as a shadow caster
	Pass {
		Name "ShadowCaster"
		Tags { "LightMode" = "ShadowCaster" }
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 2.0
		#pragma multi_compile_shadowcaster
		#include "UnityCG.cginc"
		
		sampler2D _MainTex;
		float4 _MainTex_ST;

		struct fragOut
		{
			half4 color : SV_Target;
			float depth : SV_Depth;
		};

		struct v2f { 
			float2 uv : TEXCOORD0;
			V2F_SHADOW_CASTER;
			
		};

		v2f vert( appdata_base v )
		{
			v2f o;
			o.uv = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
			TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
			return o;
		}

		half4 frag( v2f i ) : SV_Target
		{
			clip(tex2D(_MainTex, i.uv).a - 0.999);
			SHADOW_CASTER_FRAGMENT(i)
		}
		ENDCG
	}
	
}

Fallback "Unlit/Transparent"

}
