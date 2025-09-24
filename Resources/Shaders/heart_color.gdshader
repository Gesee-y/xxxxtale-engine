shader_type canvas_item;

uniform int type = 0;
uniform bool inv_frames = false;
uniform bool hole = true;

void fragment() {
	vec3 color = vec3(1.0);
	float alpha = COLOR.a;
	
	switch(type){
		case 0:
			color = vec3(1.0,0.0,0.0);
			break;
		case 1:
			color = vec3(0.0,0.0,0.8);
			break;
		case 2:
			color = vec3(0.0,0.7,0.0);
			break;
		case 3:
			color = vec3(1.0,1.0,0.0);
			break;
	}
	if (inv_frames){
		if (sin(TIME*20.0) >= 0.0){
			color/=2.0;
		}
	}
	
	if (hole){
		vec2 uv = UV*2.0-1.0;
		uv.y-=0.075;
		float len = length(uv);
		len = smoothstep(0.1,0.2,len) * (step(0.5,length(uv)));
		color *= len;
	}
	
	COLOR = vec4(color,alpha);
}