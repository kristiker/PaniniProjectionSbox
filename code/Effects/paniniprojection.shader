HEADER
{
    Description = "Panini Screen Projection";
    DevShader = true;
    Version = 1;
}

MODES
{
    Default();
    VrForward();
}

COMMON
{
    #include "postprocess/shared.hlsl"
}

struct VertexInput
{
    float3 vPositionOs : POSITION < Semantic( PosXyz ); >;
    float2 vTexCoord : TEXCOORD0 < Semantic( LowPrecisionUv ); >;
};

struct PixelInput
{
    float2 vTexCoord : TEXCOORD0;

	// VS only
	#if ( PROGRAM == VFX_PROGRAM_VS )
		float4 vPositionPs		: SV_Position;
	#endif

	// PS only
	#if ( ( PROGRAM == VFX_PROGRAM_PS ) )
		float4 vPositionSs		: SV_ScreenPosition;
	#endif
};

VS
{
    PixelInput MainVs( VertexInput i )
    {
        PixelInput o;
        o.vPositionPs = float4(i.vPositionOs.xyz, 1.0f);
        o.vTexCoord = i.vTexCoord;
        return o;
    }
}

PS
{
    RenderState( DepthWriteEnable, false );
    RenderState( DepthEnable, false );

    CreateTexture2D( g_tColorBuffer ) < Attribute( "ColorBuffer" );
                                        SrgbRead( true );
                                        Filter( MIN_MAG_LINEAR_MIP_POINT );
                                        AddressU( BORDER );
                                        AddressV( BORDER ); >;


    float g_flProjectionOut < Range(0.0, 0.999); UiType(Slider); UiGroup("Stretch"); >;

    float g_flProjectionIn < Range(0.0, 2.0); UiType(Slider); UiGroup("Squeeze"); >;
    float g_flManualScreenFit < Default(1.0); Range(0.0, 2.0); UiType(Slider); UiGroup("Squeeze"); >;


    float g_flProjectionValue < Expression(g_flProjectionIn - g_flProjectionOut); >;

    float2 PaniniProjection( float2 vTexCoords, float flDistance )
    {
        float flViewDistance = 1.0f + flDistance;
        float flHypotenuse = vTexCoords.x * vTexCoords.x + flViewDistance * flViewDistance;

        float flIntersectionDistance = vTexCoords.x * flDistance;
        float flIntersectionDiscriminator = sqrt( flHypotenuse - flIntersectionDistance * flIntersectionDistance );

        float flCylindricalDistanceNoD = ( -flIntersectionDistance * vTexCoords.x + flViewDistance * flIntersectionDiscriminator ) / flHypotenuse;
        float flCylindricalDistance = flCylindricalDistanceNoD + flDistance;

        float2 vPosition = vTexCoords * (flCylindricalDistance / flViewDistance);
        return vPosition / flCylindricalDistanceNoD;
    }

    float4 MainPs( PixelInput i ) : SV_Target0
    {
        // Get the current screen texture coordinates
        float2 vScreenUv = i.vPositionSs.xy / g_vRenderTargetSize;

        vScreenUv = vScreenUv * 2.0 - 1.0; // change to [-1:1]
        vScreenUv = PaniniProjection(vScreenUv, g_flProjectionValue);

        // TODO: Proper screen fitting.
        vScreenUv /= g_flManualScreenFit;

        vScreenUv = (vScreenUv * .5 + .5); // restore -> [0:1]
        return float4( Tex2D( g_tColorBuffer, vScreenUv).rgb, 1.0f );
    }
}
