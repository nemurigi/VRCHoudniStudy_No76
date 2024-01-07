Shader "Unlit/Custom_VAT_Unlit"
{
    Properties
    {
        _VATPositionMap("Position Map", 2D) = "black"{}
        _VATNormalMap("Normal Map", 2D) = "black"{}
        _VATTime("Time", range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        // Cull Off
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                uint id : SV_VERTEXID;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            texture2D _VATPositionMap;
            texture2D _VATNormalMap;
            float _VATTime;

            v2f vert (appdata v)
            {
                v2f o;

                float3 pos = v.vertex.xyz;
                float3 normal = v.normal.rgb;
                // uint id = v.id;
                uint id = floor(v.uv.x);

                // フレームの算出
                float time = frac(_Time.y / 10.0);
                float fps = 24.0;
                float maxFrame = 240.0;
                uint frame = fmod(floor(time*maxFrame), maxFrame);


                // VATのフェッチ
                pos = _VATPositionMap[uint2(id, frame)].rgb;
                pos.x = -pos.x;
                normal = _VATNormalMap[uint2(id, frame)].rgb;

                v.vertex.rgb = pos;
                v.normal.rgb = normal;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
