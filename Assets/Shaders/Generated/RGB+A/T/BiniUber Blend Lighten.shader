Shader "BiniUber/RGB+A/T/Blend: Lighten" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		[NoScaleOffset] _MainTex_Alpha ("Main Texture (Alpha)", 2D) = "white" {}
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		Pass {
			Blend One One // Note: Min/Max mode ignores blend factors
			BlendOp Max
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			#define USE_SEPARATE_ALPHA 1
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			struct appdata {
				DEFAULT_VERTEX_INPUT
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				fixed4 final = TINT(TEX_RGBA(_MainTex, i.texcoord0));
				return fixed4(final.rgb * final.a, final.a);
			}
			ENDCG
		}
	}
}
