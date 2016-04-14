/* Copying and distribution of this file, with or without modification,
 * are permitted in any medium without royalty. This file is offered as-is,
 * without any warranty.
 */

/*! @file template.h
 * @brief Global header file for the template application.
 */
#ifndef TEMPLATE_H_
#define TEMPLATE_H_

/*--------------------------- Includes -----------------------------*/
#include <stdio.h>
#include "oscar.h"

/*--------------------------- Settings ------------------------------*/
/*! @brief Timeout (ms) when waiting for a new picture. */
#define CAMERA_TIMEOUT 1

/*------------------- Main data object and members ------------------*/



/*! @brief The structure storing all important variables of the application.
 * */
struct TEMPLATE
{
	/*! @brief The frame buffer for the frame capture device driver.*/
	uint8 u8FrameBuffer[ 2*OSC_CAM_MAX_IMAGE_HEIGHT*OSC_CAM_MAX_IMAGE_WIDTH];
	/*! @brief The buffer for the Y-component of the picture */
	uint8 u8pictureBuffer[ OSC_CAM_MAX_IMAGE_HEIGHT*OSC_CAM_MAX_IMAGE_WIDTH];
	/*! @brief picture structure for saving image */ 
	struct OSC_PICTURE pictureRaw;
	/*! @brief The last raw image captured. Always points to the frame
	 * buffer. */
	uint8* pRawImg;
};

extern struct TEMPLATE data;

#endif //#define TEMPLATE_H_
