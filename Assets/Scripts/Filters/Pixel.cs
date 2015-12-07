using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Pixel : MonoBehaviour 
{
	Material material;
	public int size = 64;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Pixel") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Size", size);
		Graphics.Blit (source, destination, material);
	}
}
