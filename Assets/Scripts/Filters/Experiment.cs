using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Experiment : MonoBehaviour 
{
	Material material;
	public float offset = 0.2f;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Experiment") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Offset", offset);
		Graphics.Blit (source, destination, material);
	}
}
