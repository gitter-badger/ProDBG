#pragma once

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

namespace entry
{
	struct MouseState;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

namespace prodbg
{

void IMGUI_setup(int width, int height);
void IMGUI_preUpdate(float x, float y, int mouseLmb);
void IMGUI_postUpdate();

}