Shader "Hidden/Tunnel" {
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
			float _ScaleAngle;
			float _ScaleDistance;
			float _Offset;

			fixed4 frag (v2f i) : SV_Target
			{
				// Pixel position -> Texture coordinates -> UV
				float2 uv = i.uv;

				// Calculate angle and distance from center
				float2 center = uv - float2(0.5, 0.5);
				// Fixed aspect ratio
				center.x *= _ScreenParams.x / _ScreenParams.y;
				float angle = atan2(center.y, center.x);
				float dist = length(center);

				// Setup UV as angle and distance
				uv.x = angle * _ScaleAngle;
				uv.y = (dist + _Offset) * _ScaleDistance;

				// Wrap UV 
				uv = fmod(abs(uv), 1.0);

				// Color from texture and uv
				fixed4 col = tex2D(_MainTex, uv);
				
				return col;
			}
			ENDCG
		}
	}
}
