attribute vec4 a_Position;
uniform mat4 u_Mvp;

void main()
{
 gl_Position = u_Mvp * a_Position;
}
