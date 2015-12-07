Shader "Unlit/Planet"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_GrassTex ("Grass Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Utils.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float3 viewDir : TEXCOORD1;
				float4 normal : NORMAL;
			};

			sampler2D _MainTex;
			sampler2D _GrassTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o = (v2f)0;

				float t = _Time * 2.0;
				
				float3 seed = (v.vertex.xyz + float3(0,t*2.0,t)) * 4.0;
				// seed = floor(seed * 2.0) / 2.0; 

				float n = noiseIQ(seed);
				v.vertex.xyz += v.normal * n * 0.2;

				o.color.r = n;

        o.viewDir = WorldSpaceViewDir(v.vertex);
        o.normal = v.normal;

				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				// uv = pixelize(uv, 64.0);

				fixed4 glow = float4(1,1,1,1);
				fixed4 water = float4(0,0,1,1);
				fixed4 ground = tex2D(_MainTex, uv);
				fixed4 grass = tex2D(_GrassTex, uv);
				float ratioGround = smoothstep(0.2, 0.4, i.color.r);
				float ratioGrass = smoothstep(0.4, 0.6, i.color.r);
				fixed4 col = lerp(lerp(water, ground, ratioGround), grass, ratioGrass);

				float light = 1 - dot(normalize(i.viewDir), i.normal);
				col = lerp(col, i.normal * 0.5 + 0.5, light);

				return col;
			}
			ENDCG
		}
	}
}
