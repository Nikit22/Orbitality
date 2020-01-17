Shader "BiniUber/RGB+A/TVC/Blend: Dodge" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		[NoScaleOffset] _MainTex_Alpha ("Main Texture (Alpha)", 2D) = "white" {}
	}
	
	// Actual dodge is impossible with conventional shader,
	// since a color is divided by color (in other words,
	// a color has to be multiplied by something greater than 1).
	
	// dodge: result = base / (1 - blend)
	// pseudo-dodge: result = base + base * k, where 0 <= k <= 1
	// base / (1 - blend) = base * (1 + k)
	// 1 + k = 1 / (1 - blend)
	// k = (1 - (1 - blend)) / (1 - blend)
	// k = blend / (1 - blend)
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		Pass {
			Blend DstColor One, One One
			BlendOp Add
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			#define USE_SEPARATE_ALPHA 1
			#define USE_VERTEX_COLOR 1
			#define USE_CONSTANT_COLOR 1
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
				half4 final = TINT(TEX_RGBA(_MainTex, i.texcoord0));
				final.rgb *= final.a;
				return fixed4(final.rgb / max(1 - final.rgb, 0.001), 1);
			}
			ENDCG
		}
	}
}
