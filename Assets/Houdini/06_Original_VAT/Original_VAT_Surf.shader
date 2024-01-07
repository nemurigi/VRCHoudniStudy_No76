Shader "NmrgLibrary/VRCHoudniStudy/Original_VAT_Surf"
{
    Properties
    {
        _VATPositionMap("Position Map", 2D) = "black"{}
        _VATNormalMap("Normal Map", 2D) = "black"{}
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _VATPositionMap;
        float4 _VATPositionMap_TexelSize;
        sampler2D _VATNormalMap;
        float4 _VATNormalMap_TexelSize;

        void vert(inout appdata_full v){
                float3 pos = v.vertex.xyz;
                float3 normal = v.normal.rgb;
                // uint id = v.id;
                float id = floor(v.texcoord.x);

                // フレームの算出
                float animLength = 10.0;
                float fps = 24.0;
                float maxFrame = 240.0;
                float time = frac(_Time.y / animLength);
                float frame = fmod(floor(time*maxFrame), maxFrame);

                float2 uv = float2(id+0.5,frame+0.5) / float2(_VATPositionMap_TexelSize.zw);

                pos = tex2Dlod(_VATPositionMap, float4(uv,0,0)).rgb;
                pos.x = -pos.x;
                normal = tex2Dlod(_VATNormalMap, float4(uv,0,0)).rgb;
                normal.x = -normal.x;

                v.vertex.rgb = pos;
                v.normal.rgb = normal;
        }

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
