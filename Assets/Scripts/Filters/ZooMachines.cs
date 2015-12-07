
using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ZooMachines : MonoBehaviour 
{
	Material material;
	public int pixelSize = 64;
	public float scale = 40f;
	public float offset = 0.5f;
	public float treshold = 0.5f;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/ZooMachines") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_PixelSize", pixelSize);
		material.SetFloat("_Scale", scale);
		material.SetFloat("_Offset", offset);
		material.SetFloat("_Treshold", treshold);
		Graphics.Blit (source, destination, material);
	}
}
