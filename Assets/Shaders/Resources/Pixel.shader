Shader "Hidden/Pixel" {
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
			float _Size;

			fixed4 frag (v2f i) : SV_Target {

				// Pixel position -> Texture coordinates -> UV
				float2 uv = i.uv;

				float2 pixelSize = float2(_Size, _Size);

				// Aspect ratio (Screen.width / Screen.height)
				pixelSize.x *= _ScreenParams.x / _ScreenParams.y;

				// Pixelize
				uv = floor(uv * pixelSize) / pixelSize;

				// Color from texture and uv
				fixed4 col = tex2D(_MainTex, uv);

				return col;
			}
			ENDCG
		}
	}
}
