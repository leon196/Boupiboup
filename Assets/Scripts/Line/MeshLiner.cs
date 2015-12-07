
// Many thanks to gszauer
// https://gist.github.com/gszauer/5718441

/*
Generates a trail that is always facing upwards using the scriptable mesh interface.
vertex colors and uv's are generated similar to the builtin Trail Renderer.
To use it
1. create an empty game object
2. attach this script and a MeshRenderer
3. Then assign a particle material to the mesh renderer
*/

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class TrailSection
{
    public Vector3 point;
    public Vector3 upDir;
    public float distance;
    public float time;
}

public class Trail : MonoBehaviour
{
    public float height = 0.1f;
    public float minDistance = 0.1f;
    // public float minTime = 0.1f;
    float timeStarted = 0f;
    bool alwaysUp = false;
    bool _emit = false;
    public bool emit { get; set; }
    Transform originalParent;
    Vector3 originalPosition;
    Quaternion originalRotation;

    Color startColor = Color.white;
    Color endColor = Color.black;

    Mesh mesh;
    private List<TrailSection> sectionList = new List<TrailSection>();

    void Start ()
    {
        this.Reset();
    }

    public void Reset ()
    {
        this.sectionList = new List<TrailSection>();
        this.GetComponent<MeshFilter>().mesh = null;
        this.GetComponent<MeshFilter>().mesh = new Mesh();
        this.mesh = this.GetComponent<MeshFilter>().mesh;
        this.timeStarted = Time.time;
        if (!this.originalParent) {
            this.originalParent = this.transform.parent;
            this.originalPosition = this.transform.localPosition;
            this.originalRotation = this.transform.localRotation;
        }
        this.transform.parent = this.originalParent;
        this.transform.localPosition = this.originalPosition;
        this.transform.localRotation = this.originalRotation;
        this.emit = false;
    }

    public void DropMesh ()
    {
        this.transform.parent = null;
    }

    void LateUpdate ()
    {
        if (emit)
        {
            Vector3 position = this.transform.position;
            float timeElapsed = Time.time - this.timeStarted;

            // Use matrix instead of transform.TransformPoint for performance reasons
            Matrix4x4 localSpaceTransform = transform.worldToLocalMatrix;

            // Remove old sectionList
            // if (sectionList.Count > 0 && now > sectionList[sectionList.Count - 1].time + time) {
            //     sectionList.RemoveAt(sectionList.Count - 1);
            // }

            // Add a new trail section
            // if (sectionList.Count == 0 || (sectionList[0].point - position).sqrMagnitude > minDistance * minDistance)
            if (sectionList.Count == 0 || (sectionList[0].point - position).magnitude > minDistance)// || timeElapsed > minTime)
            {
                TrailSection section = new TrailSection();
                section.point = position;
                if (alwaysUp) {
                    section.upDir = Vector3.up;
                }
                else {
                    section.upDir = transform.TransformDirection(Vector3.up);
                }
                float distance = 0f;
                if (sectionList.Count > 0) {
                    int i = sectionList.Count - 1;
                    distance += sectionList[i].distance;
                    Vector3 p1 = localSpaceTransform.MultiplyPoint(section.point);// - upDir * height * 0.5f);
                    Vector3 p2 = localSpaceTransform.MultiplyPoint(sectionList[i].point);// - upDir * height * 0.5f);
                    distance += Vector3.Distance(p1, p2);
                }
                section.distance = distance;
                section.time = Time.time;
                sectionList.Insert(0, section);
                // this.timeStarted = Time.time;
            }

            // Rebuild the mesh
            mesh.Clear();

            // We need at least 2 sectionList to create the line
            if (sectionList.Count < 2) {
                return;
            }

            Vector3[] vertices = new Vector3[sectionList.Count * 2];
            Color[] colors = new Color[sectionList.Count * 2];
            Vector2[] uv = new Vector2[sectionList.Count * 2];

            TrailSection previousSection = sectionList[0];
            TrailSection currentSection = sectionList[0];

            // Generate vertex, uv and colors
            for (int i = 0; i < sectionList.Count; i++)
            {
                previousSection = currentSection;
                currentSection = sectionList[i];
                // Calculate u for texture uv and color interpolation
                // float u = 0.0f;
                // if (i != 0) {
                    // u = (Time.time - currentSection.time) / time;
                    // u = (i % 2f);
                // }

                // Calculate upwards direction
                Vector3 upDir = currentSection.upDir;

                // Generate vertices
                vertices[i * 2 + 0] = localSpaceTransform.MultiplyPoint(currentSection.point - upDir * height * 0.5f);
                vertices[i * 2 + 1] = localSpaceTransform.MultiplyPoint(currentSection.point + upDir * height * 0.5f);

                uv[i * 2 + 0] = new Vector2(currentSection.distance, 0f);
                uv[i * 2 + 1] = new Vector2(currentSection.distance, 1f);

                // fade colors out over time
                Color interpolatedColor = Color.Lerp(startColor, endColor, i / (float)sectionList.Count);
                colors[i * 2 + 0] = interpolatedColor;
                colors[i * 2 + 1] = interpolatedColor;
            }

            // Generate triangles indices
            int[] triangles = new int[(sectionList.Count - 1) * 2 * 3];
            for (int i = 0; i < triangles.Length / 6; i++)
            {
                triangles[i * 6 + 0] = i * 2;
                triangles[i * 6 + 1] = i * 2 + 1;
                triangles[i * 6 + 2] = i * 2 + 2;

                triangles[i * 6 + 3] = i * 2 + 2;
                triangles[i * 6 + 4] = i * 2 + 1;
                triangles[i * 6 + 5] = i * 2 + 3;
            }

            // Assign to mesh
            mesh.vertices = vertices;
            mesh.colors = colors;
            mesh.uv = uv;
            mesh.triangles = triangles;
        }
    }
}