using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CanalPlus : MonoBehaviour 
{
	Material material;
	public float scale = 64f;
	public float intensity = 0.1f;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/CanalPlus") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Scale", scale);
		material.SetFloat("_Intensity", intensity);
		Graphics.Blit (source, destination, material);
	}
}
