using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class FishEye : MonoBehaviour 
{
	Material material;
	public float scale = 4f;
	public float lensSize = 4f;
	Vector4 mousePositionRatio;

	// Creates a private material used to the effect
	void Awake ()
	{
		mousePositionRatio = new Vector4();
		material = new Material( Shader.Find("Hidden/FishEye") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		mousePositionRatio.x = Input.mousePosition.x / Screen.width;
		mousePositionRatio.y = Input.mousePosition.y / Screen.height;
		material.SetVector("_Target", mousePositionRatio);
		material.SetFloat("_Scale", scale);
		material.SetFloat("_LensSize", lensSize);
		Graphics.Blit (source, destination, material);
	}
}
