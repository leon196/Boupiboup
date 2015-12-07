using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Planet : Astre {

	Vector3 velocity = Vector3.right;
	List<Astre> astreList;

	void Start () 
	{
		// velocity = new Vector3(Random.Range(-1f, 1f), Random.Range(-1f, 1f), Random.Range(-1f, 1f));
		// velocity = Vector3.Normalize(velocity);
		astreList = new List<Astre>();
		Astre[] astreArray = FindObjectsOfType<Astre>();	
		Debug.Log(astreArray.Length);
		foreach (Astre astre in astreArray) {
			if (astre.GetInstanceID() != gameObject.GetInstanceID()) {
				astreList.Add(astre);
			}
		}
	}
	
	void Update () 
	{
		Vector3 vector = Vector3.zero;
		foreach (Astre astre in astreList) {
			Vector3 normal = Vector3.Normalize(astre.transform.position - transform.position);
			float dist = Vector3.Distance(astre.transform.position, transform.position);
			vector += normal * astre.mass / Mathf.Max(1f, dist);
			// vector += normal * ((mass * astre.mass) / Mathf.Pow(Mathf.Max(0.1f, dist), 2f)) ;
		}
		velocity += vector;
		velocity = Vector3.ClampMagnitude(velocity, 2f);
		transform.position += velocity;
	}
}
