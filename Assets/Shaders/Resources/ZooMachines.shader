Shader "Hidden/ZooMachines"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			
			#include "UnityCG.cginc"
			#include "ClassicNoise2D.cginc"
			#include "Utils.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _Scale;
			float _PixelSize;
			float _Offset;
			float _Treshold;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				float2 pixelSize = float2(_PixelSize, _PixelSize);
				pixelSize.x *= _ScreenParams.x / _ScreenParams.y;
				uv = floor(uv * pixelSize) / pixelSize;

				// Maths infos about the current pixel position
				float2 center = uv - float2(0.5, 0.5);
				float angle = atan2(center.y, center.x);
				float radius = length(center);
				float ratioAngle = (angle / PI) * 0.5 + 0.5;

				// Displacement from noise
				float2 angleUV = fmod(abs(float2(0, angle / PI)), 1.0);
				float offset = (cnoise((angleUV) * _Scale) * 0.5 + _Treshold) * _Offset;

				// Displaced pixel color
				float2 p = float2(cos(angle), sin(angle)) * offset + float2(0.5, 0.5);

				// Apply displacement
				uv = lerp(uv, p, step(offset, radius));

				half3 color = tex2D(_MainTex, uv).rgb;

				// Just Yellow and Red
				float lum = luminance(color);
				float3 black = float3(0.0, 0.0, 0.0);
				float3 red = float3(1.0, 0.0, 0.0);
				float3 yellow = float3(1.0, 1.0, 0.0);

				color = lerp(float3(0, 0, 0), float3(1,0,0), step(0.45, lum));
				color = lerp(color, float3(1,1,0), step(0.65, lum));
				color = lerp(color, float3(1,1,1), step(0.9, lum));


				return float4(color, 1.0);
			}
			ENDCG
		}
	}
}
