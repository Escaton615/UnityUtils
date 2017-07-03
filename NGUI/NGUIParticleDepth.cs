using UnityEngine;

/* set particle renderer's renderqueue based on parent ngui panel 
 * NOTE: particle system's "order in layer" property seems to add 100 per layerorder to renderqueue value;
 *       Manual adjusting seems required if it's not zero.
 * CQ, 20170627
 */

public class NGUIParticleDepth : MonoBehaviour
{

    public bool EveryFrame = false;
    public bool IncludesChildren = true;
    public bool ParticleEffectsOnly = true;
    public int Depth = 0;
	void Start () {
        
		setDepth();
	}
	
	void Update () {
	    if (EveryFrame)
	    {
	        setDepth();
	    }
	}

    private ParticleSystem[] particleSystems;
    private Renderer[] renderers;

    private void setDepth()
    {
        var fatherPanel = NGUITools.FindInParents<UIPanel>(gameObject);
        if (fatherPanel == null || fatherPanel.drawCalls == null || fatherPanel.drawCalls.Count <= 0) return;

        int baseDepth = fatherPanel.drawCalls[0].renderQueue;

        if (ParticleEffectsOnly)
        {
            if (particleSystems == null)
            {
                particleSystems = IncludesChildren
                    ? gameObject.GetComponentsInChildren<ParticleSystem>()
                    : gameObject.GetComponents<ParticleSystem>();
            }
            foreach (var ps in particleSystems)
            {
                var r = ps.GetComponent<Renderer>();
                if (r != null && r.sharedMaterial != null)
                {
                    r.material.renderQueue = baseDepth + Depth;
                }
            }
        }
        else
        {
            if (renderers == null)
            {
                renderers = IncludesChildren
                    ? gameObject.GetComponentsInChildren<Renderer>()
                    : gameObject.GetComponents<Renderer>();
            }
            foreach (var r in renderers)
            {
                if (r != null && r.sharedMaterial != null)
                {
                    r.material.renderQueue = baseDepth + Depth;
                }
            }
        }
    }
}
