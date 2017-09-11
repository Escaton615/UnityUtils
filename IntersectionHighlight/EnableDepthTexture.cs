using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnableDepthTexture : MonoBehaviour {

	// Use this for initialization
	void Start () {
		GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
	}
	
	// Update is called once per frame
//	void Update () {
//		
//	}
}
