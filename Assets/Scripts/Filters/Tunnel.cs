using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Tunnel : MonoBehaviour 
{
	Material material;
	public float offset = 0f;
	public float scaleAngle = 2f;
	public float scaleDistance = 2f;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Tunnel") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_ScaleAngle", scaleAngle);
		material.SetFloat("_ScaleDistance", scaleDistance);
		material.SetFloat("_Offset", offset);
		Graphics.Blit (source, destination, material);
	}
}
