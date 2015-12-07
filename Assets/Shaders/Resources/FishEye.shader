Shader "Hidden/FishEye" {
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
			float _Scale;
			float _LensSize;
			float2 _Target;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				// Distance from target
				float2 center = uv - _Target;
				float dist = length(center);

				// Offset to center UVs (for scaling)
				uv -= 0.5;

				// Calculate distortion scale
				float d = dist * _LensSize;
				d = 1.0 - clamp(d, 0.1, 1.0);
				d = pow(d, 2.0);

				// Apply distortion
				uv /= d;
				uv /= _Scale;

				// Reset offset
				uv += 0.5;

				// Wrap UV with a seamless function from Utils.cginc
				uv.x = kaleido(abs(uv.x), 1.0);
				uv.y = kaleido(abs(uv.y), 1.0);
				
				// Color from texture and uv
				fixed4 col = tex2D(_MainTex, uv);
				
				// Light of color from distance
				col.rgb *= d;

				return col;
			}
			ENDCG
		}
	}
}
