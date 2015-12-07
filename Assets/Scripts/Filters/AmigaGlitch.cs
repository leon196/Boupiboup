using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class AmigaGlitch : MonoBehaviour 
{
	Material material;
	public float speed = 10f;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/AmigaGlitch") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Speed", speed);
		Graphics.Blit (source, destination, material);
	}
}
