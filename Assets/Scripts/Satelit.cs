using UnityEngine;
using System.Collections;

public class Satelit : MonoBehaviour {

	public Transform target;
	public float radius = 4f;
	public float speed = 2f;
	float angle = 0f;

	// Use this for initialization
	void Start () {
		// radius = Vector3.Distance(target.position, transform.position);
		Orbit();
	}
	
	// Update is called once per frame
	void Update () {
		Orbit();
	}

	void Orbit () {
		Vector3 pos = target.position;
		pos.x += Mathf.Cos(angle) * radius;
		pos.z += Mathf.Sin(angle) * radius;
		transform.position = pos;
		angle += speed * Time.deltaTime;
	}
}
