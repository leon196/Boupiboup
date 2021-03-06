Shader "Hidden/AmigaGlitch" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Cull Off ZWrite Off ZTest Always
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Utils.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _Speed;

			fixed4 frag (v2f i) : SV_Target
			{
				// Pixel position -> Texture coordinates -> UV
				float2 uv = i.uv;

				float t = _Time * _Speed;
				
				// Setup an oscillator (0 -> 1 -> 0 -> 1 -> etc.)
				float osc = sin(t) * 0.5 + 0.5;

				// Clamp UV
				uv.y = max(uv.y, osc);

				// Color from texture and uv
				fixed4 col = tex2D(_MainTex, uv);

				return col;
			}
			ENDCG
		}
	}
}
