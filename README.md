# PaniniProjectionSbox
Panini projection postprocess shader
| Squeeze | Stretch |
| - | - |
| ![image](https://github.com/kristiker/PaniniProjectionSbox/assets/26466974/a85def97-d811-47df-90a9-70c9679f357f) | ![image](https://github.com/kristiker/PaniniProjectionSbox/assets/26466974/d9bc6f02-4580-4b47-855f-aeaa273d2d3e)  |
| Used to tone down side effects of high FoV. | Gives the player similar effects as high FoV without zooming out the center view. |


This shader is material based. If you want to change the projection values dynamically through code, you need to set up dynamic expressions in the material. The only direct attribute is `ColorBuffer`.

Note: Squeeze will scale the image center up, causing center blurrines. The only way to overcome this issue is to render the game at higher than 1.0x screen res, or to apply upscaling methods such as FSR.

Read more: https://docs.unrealengine.com/5.2/en-US/panini-projection-in-unreal-engine
