using Sandbox;

[SceneCamera.AutomaticRenderHook]
public partial class PaniniProjection : RenderHook
{
	RenderAttributes attributes = new RenderAttributes();
	Material effectMaterial = Material.Load( "code/effects/paniniprojection.vmat" );

	public override void OnStage( SceneCamera target, Stage renderStage )
	{
		if ( renderStage == Stage.AfterTransparent )
		{
			Graphics.GrabFrameTexture( "ColorBuffer", attributes );

			// Draw our effect material, which is probably using a special post process
			// shader that uses all the attributes to do cool effects
			Graphics.Blit( effectMaterial, attributes );
		}
	}
}
