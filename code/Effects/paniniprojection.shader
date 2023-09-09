//=================================================================================================
// Reconstructed with Source 2 Viewer 5.0.0.0 - https://valveresourceformat.github.io
//=================================================================================================
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

FEATURES
{
}

COMMON
{
    #include "system.fxc"    
}

struct VS_INPUT
{
    float3 vPositionOs : POSITION0  < Semantic( PosXyz ); >;                                      
    float2 vTexCoord   : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                              
};

VS
{
}

PS
{
    
    cbuffer PerViewConstantBuffer_t
    {
        float4x4 g_matWorldToProjection;
        float4x4 g_matProjectionToWorld;
        float4x4 g_matWorldToView;
        float4x4 g_matViewToProjection;
        float4 g_vInvProjRow3;
        float4 g_vClipPlane0;
        float g_flToneMapScalarLinear;
        float g_flLightMapScalar;
        float g_flEnvMapScalar;
        float g_flToneMapScalarGamma;
        float3 g_vCameraPositionWs;
        float g_flViewportMinZ;
        float3 g_vCameraDirWs;
        float g_flViewportMaxZ;
        float3 g_vCameraUpDirWs;
        float g_flTime;
        float3 g_vDepthPsToVsConversion;
        float g_flNearPlane;
        float g_flFarPlane;
        float g_flLightBinnerFarPlane;
        float2 g_vInvViewportSize;
        float2 g_vViewportToGBufferRatio;
        float2 g_vMorphTextureAtlasSize;
        float4 g_vInvGBufferSize;
        float2 g_vViewportOffset;
        float2 g_vViewportSize;
        float2 g_vRenderTargetSize;
        float g_flFogBlendToBackground;
        float g_flHenyeyGreensteinCoeff;
        float3 g_vFogColor;
        float g_flNegFogStartOverFogRange;
        float g_flInvFogRange;
        float g_flFogMaxDensity;
        float g_flFogExponent;
        float g_flMod2xIdentity;
        bool2 g_bRoughnessParams;
        bool g_bStereoEnabled;
        float g_flStereoCameraIndex;
        float3 g_vMiddleEyePositionWs;
        float g_flPad2;
        float4x4 g_matWorldToProjectionMultiview[2];
        float4 g_vCameraPositionWsMultiview[2];
        float4 g_vFrameBufferCopyInvSizeAndUvScale;
        float4 g_vCameraAngles;
        float4 g_vWorldToCameraOffset;
        float4 g_vWorldToCameraOffsetMultiview[2];
        float4 g_vPerViewConstantExtraData0;
        float4 g_vPerViewConstantExtraData1;
        float4 g_vPerViewConstantExtraData2;
        float4 g_vPerViewConstantExtraData3;
        float4x4 m_matPrevProjectionToWorld;
    };
    
    float g_flProjectionValue < UiType(Slider); Expression(g_flProjectionIn-g_flProjectionOut); >;
    CreateTexture2DWithoutSampler(g_tColorBuffer) < Attribute("ColorBuffer"); SrgbRead(true); >;
    
    // Squeeze
    float g_flManualScreenFit < Default(1); Range(0, 2); UiType(Slider); UiGroup("Squeeze"); >;
    float g_flProjectionIn < Range(0, 2); UiType(Slider); UiGroup("Squeeze"); >;
    
    // Stretch
    float g_flProjectionOut < Range(0, 0.999); UiType(Slider); UiGroup("Stretch"); >;
}
