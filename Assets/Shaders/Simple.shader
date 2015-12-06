Shader "Custom/Simple" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_ColorGlow ("Color Glow", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Noise ("Noise (RGB)", 2D) = "white" {}
		_Noise2 ("Noise (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Cull Off
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard vertex:vert
		#include "Noise3D.cginc"
		#define PI 3.141592653589
		#define PI2 6.283185307179


		sampler2D _MainTex;
		sampler2D _Noise;
		sampler2D _Noise2;

		struct Input {
			float2 uv_MainTex;
          	float3 viewDir;
          	float3 normal;
          	float height;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		fixed4 _ColorGlow;

		float2 wrapUV (float2 uv) {
			return fmod(abs(uv), 1.0);
		}

		float2 dentDeScie (float2 v) {
		  	return float2(1.0 - abs(fmod(abs(v.x), 1.0) * 2.0 - 1.0), 1.0 - abs(fmod(abs(v.y), 1.0) * 2.0 - 1.0));
		}

		float dentDeScie (float x) {
		  	return 1.0 - abs(fmod(abs(x), 1.0) * 2.0 - 1.0);
		}

		float easeInExpo (float t, float b, float c, float d) {
			return c * pow( 2.0, 10.0 * (t/d - 1.0) ) + b;
		}

		void vert (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);
			float2 uv1 = v.texcoord.xy;
			float2 uv2 = v.texcoord.xy;
			float t = _Time;
			float2 center = v.texcoord.xy - 0.5;
			float angle = atan2(center.y, center.x);
			float dist = length(center);
			float spiral = pow(dist, 2.0) * 10.0 - t * 10.0;
			center = float2(cos(angle + spiral), sin(angle + spiral)) * dist;
			// uv1 = center;
			// uv1 = center + 0.5;
			uv1 = center;
			uv1 += 0.5;
			// uv1 += float2(0, angle);
			// uv1 *= 0.6;
			// uv1 = dentDeScie(uv1);
			uv2 -= float2(0, t * 0.5);
			uv2 *= 0.5;
			uv2 = dentDeScie(uv2);
			float height = tex2Dlod(_Noise, float4(uv1, 0, 0)).r * 1.5;
			height += tex2Dlod(_Noise, float4(uv2, 0, 0)).r * 0.5;
			// height += tex2Dlod(_Noise, float4(-uv2, 0, 0)).r;

			v.vertex.xyz += v.normal * height * 0.01;
			o.normal = v.normal;
			o.viewDir = WorldSpaceViewDir(v.vertex).xyz;

			height /= 2;
			o.height = height;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float shade = 1 - dot(IN.viewDir, -IN.normal);
			o.Emission = lerp(c.rgb, _ColorGlow, shade * IN.height);
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
