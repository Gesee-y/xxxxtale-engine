shader_type canvas_item;

uniform float spd1 = 1;
uniform float distance1 = 2;
uniform float spd2 = 1;
uniform float siner1 = 0;
uniform float Yval = 40;

void vertex() {
	if (VERTEX.y <Yval){
		VERTEX.x += siner1*distance1;
	}
}