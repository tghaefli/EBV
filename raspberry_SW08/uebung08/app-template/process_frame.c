/* Copying and distribution of this file, with or without modification,
 * are permitted in any medium without royalty. This file is offered as-is,
 * without any warranty.
 */

/*! @file process_frame.c
 * @brief Contains the actual algorithm and calculations.
 */

/* Definitions specific to this application. Also includes the Oscar main header file. */
#include "template.h"
#include <string.h>
#include <stdlib.h>

#define IMG_SIZE NUM_COLORS*OSC_CAM_MAX_IMAGE_WIDTH*OSC_CAM_MAX_IMAGE_HEIGHT

const int nc = OSC_CAM_MAX_IMAGE_WIDTH;
const int nr = OSC_CAM_MAX_IMAGE_HEIGHT;

int TextColor;


void ResetProcess()
{
	//called when "reset" button is pressed
	if(TextColor == CYAN)
		TextColor = MAGENTA;
	else
		TextColor = CYAN;
}


void ProcessFrame()
{
	char Text[] = "hallo world";
	//initialize counters
	if(data.ipc.state.nStepCounter == 1) {
		//use for initialization; only done in first step
		memset(data.u8TempImage[THRESHOLD], 0, IMG_SIZE);
		TextColor = CYAN;
	} else {
		//example for copying sensor image to background image
		memcpy(data.u8TempImage[BACKGROUND], data.u8TempImage[SENSORIMG], IMG_SIZE);

		//example for drawing output
		//draw line
		DrawLine(10, 100, 200, 20, RED);
		//draw open rectangle
		DrawBoundingBox(20, 10, 50, 40, false, GREEN);
		//draw filled rectangle
		DrawBoundingBox(80, 100, 110, 120, true, BLUE);
		DrawString(200, 200, strlen(Text), TINY, TextColor, Text);
	}
}




