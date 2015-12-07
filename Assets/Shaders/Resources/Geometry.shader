Shader "Vertex/Geometry" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
    _Size ("Size", Range(0, 1.0)) = 0.01
    _Scale ("Scale", Range(0, 1.0)) = 0.01
    _Offset ("Offset", Range(0, 1.0)) = 0.01
  }
  SubShader {
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
    Pass {
      Blend SrcAlpha OneMinusSrcAlpha
      Cull Off
      LOD 200

      CGPROGRAM
      #pragma vertex vert
      #pragma geometry geom
      #pragma fragment frag
      #include "UnityCG.cginc"
      #include "Utils.cginc"

      struct GS_INPUT
      {
        float4 pos		: POSITION;
        float3 normal	: NORMAL;
        float2 uv	: TEXCOORD0;
        float4 screenUV : TEXCOORD1;
        float3 viewDir : TEXCOORD2;
      };

      struct FS_INPUT {
        float4 pos : SV_POSITION;
        half4 color : COLOR;
        float3 normal : NORMAL;
        float2 uv : TEXCOORD0;
        float4 screenUV : TEXCOORD1;
        float3 viewDir : TEXCOORD2;
      };

      sampler2D _MainTex;
      float4 _MainTex_ST;
      fixed4 _Color;

      GS_INPUT vert (appdata_full v)
      {
        GS_INPUT o = (GS_INPUT)0;
        float t = _Time * 20.0;
        float angle = v.vertex.y * 4.0 + t;
        v.vertex.xyz = rotateY(v.vertex, angle);
        o.pos =  v.vertex;//mul(_World2Object, v.vertex);
        o.normal = v.normal;
        o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
        o.screenUV = ComputeScreenPos(o.pos);
        return o;
      }

      [maxvertexcount(3)]
      void geom(triangle GS_INPUT tri[3], inout TriangleStream<FS_INPUT> triStream)
      {
        float3 a = tri[0].pos.xyz;
        float3 b = tri[1].pos.xyz;
        float3 c = tri[2].pos.xyz;
        float3 center = (a + b + c) / 3.0;

        float2 uvA = tri[0].uv;
        float2 uvB = tri[1].uv;
        float2 uvC = tri[2].uv;
        float2 uvCenter = (uvA + uvB + uvC) / 3.0;


        // float t = _Time * 20.0;
        // float t2 = t * 10.0;
        // float angle = center.y * 4.0 + t;

        // float3 offset = float3(t, t * 3.0, 0);
        // float dist = noiseIQ((tri[0].normal + offset) * 2.0);
        // dist *= 0.05;

        // Displace
        // a += tri[0].normal * dist;
        // b += tri[1].normal * dist;
        // c += tri[2].normal * dist;

        // Rotate
        // a = rotateY(a, angle);
        // b = rotateY(b, angle);
        // c = rotateY(c, angle);

        // Scale
        // center = (a + b + c) / 3.0;
        // a += normalize(a - center) * 0.1;
        // b += normalize(b - center) * 0.1;
        // c += normalize(c - center) * 0.1;

        float3 triNormal = getNormal(a, b, c);

        FS_INPUT pIn = (FS_INPUT)0;
        pIn.pos = mul(UNITY_MATRIX_MVP, float4(a, 1.0));
        pIn.uv = tri[0].uv;
        pIn.normal = triNormal;
        pIn.color = half4(1.0,1.0,1.0,1.0);
        triStream.Append(pIn);

        pIn.pos =  mul(UNITY_MATRIX_MVP, float4(b, 1.0));
        pIn.uv = tri[1].uv;
        pIn.normal = triNormal;
        pIn.color = half4(1.0,1.0,1.0,1.0);
        triStream.Append(pIn);

        pIn.pos =  mul(UNITY_MATRIX_MVP, float4(c, 1.0));
        pIn.uv = tri[2].uv;
        pIn.normal = triNormal;
        pIn.color = half4(1.0,1.0,1.0,1.0);
        triStream.Append(pIn);
      }

      half4 frag (FS_INPUT i) : COLOR
      {
        half4 color = _Color;
        color.rgb = i.normal * 0.5 + 0.5;
        color.a = 1.0;
        return color;
      }
      ENDCG
    }
  }
  FallBack "Unlit/Transparent"
}
