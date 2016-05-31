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
#include <math.h>

#define IMG_SIZE NUM_COLORS*OSC_CAM_MAX_IMAGE_WIDTH*OSC_CAM_MAX_IMAGE_HEIGHT

const int nc = OSC_CAM_MAX_IMAGE_WIDTH;
const int nr = OSC_CAM_MAX_IMAGE_HEIGHT;

int TextColor;

/* skip pixel at border */
const int Border = 2;

/* used to store values for derivatives */
int16 imgDx[IMG_SIZE];
int16 imgDy[IMG_SIZE];

/* minimum size of objects (sum of all pixels) */
const int MinArea = 150;
const int MaxArea = 1500;
const char Characters[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

/* the number of angle bins used */
const int NumAngleBins = 8;

struct OSC_VIS_REGIONS ImgRegions;/* these contain the foreground objects */

void ChangeDetection();
void Erode_3x3(int InIndex, int OutIndex);
void Dilate_3x3(int InIndex, int OutIndex);
void DetectRegions();
void ClusterAngles();
void DrawBoundingBoxes();


void ResetProcess()
{

}


void ProcessFrame()
{
	uint32 t1, t2;
	//initialize counters
	if(data.ipc.state.nStepCounter == 1) {

	} else {
		//example for time measurement
		t1 = OscSupCycGet();

		ChangeDetection();

		Erode_3x3(THRESHOLD, INDEX0);
		Dilate_3x3(INDEX0, THRESHOLD);

		DetectRegions();

		ClusterAngles();

		DrawBoundingBoxes();

		//example for time measurement
		t2 = OscSupCycGet();

		//example for log output to console
		OscLog(INFO, "required = %d us\n", OscSupCycToMicroSecs(t2-t1));
	}
}

void ChangeDetection() {
	int r, c;
	/* angle threshold */
	//set result buffer to zero
	memset(data.u8TempImage[THRESHOLD], 0, IMG_SIZE);

	//loop over the rows
	for(r = Border*nc; r < (nr-Border)*nc; r += nc) {
		//loop over the columns
		for(c = Border; c < (nc-Border); c++) {
			/* do pointer arithmetics with respect to center pixel location */
			unsigned char* p = &data.u8TempImage[SENSORIMG][r+c];

			/* implement Sobel filter in x-direction */
			int dx =    -(int) *(p-nc-1) + (int) *(p-nc+1)
					 -2* (int) *(p-1) + 2* (int) *(p+1)
						-(int) *(p+nc-1) + (int) *(p+nc+1);

			/* implement Sobel filter in y-direction */
			int dy =    -(int) *(p-nc-1) -2* (int) *(p-nc) - (int) *(p-nc+1)
						+(int) *(p+nc-1) +2* (int) *(p+nc) + (int) *(p+nc+1);

			/* check if norm is larger than threshold */
			int df_sq = dx*dx+dy*dy;
			int thr_sq = data.ipc.state.nThreshold*data.ipc.state.nThreshold;

			if(df_sq > thr_sq) {//avoid square root
				//set pixel value to 255 in THRESHOLD image
				data.u8TempImage[THRESHOLD][r+c] = 255;
			}
			//store derivatives (int16 is enough)
			imgDx[r+c] = (int16) dx;
			imgDy[r+c] = (int16) dy;
		}
	}
}


void Erode_3x3(int InIndex, int OutIndex)
{
	int c, r;

	for(r = Border*nc; r < (nr-Border)*nc; r += nc) {
		for(c = Border; c < (nc-Border); c++) {
			unsigned char* p = &data.u8TempImage[InIndex][r+c];
			data.u8TempImage[OutIndex][r+c] = *(p-nc-1) & *(p-nc) & *(p-nc+1) &
											   *(p-1)    & *p      & *(p+1)    &
											   *(p+nc-1) & *(p+nc) & *(p+nc+1);
		}
	}
}

void Dilate_3x3(int InIndex, int OutIndex)
{
	int c, r;

	for(r = Border*nc; r < (nr-Border)*nc; r += nc) {
		for(c = Border; c < (nc-Border); c++) {
			unsigned char* p = &data.u8TempImage[InIndex][r+c];
			data.u8TempImage[OutIndex][r+c] = *(p-nc-1) | *(p-nc) | *(p-nc+1) |
											        *(p-1)    | *p      | *(p+1)    |
											        *(p+nc-1) | *(p+nc) | *(p+nc+1);
		}
	}
}


void DetectRegions() {
	struct OSC_PICTURE Pic;
	int i;

	//set pixel value to 1 in INDEX0 because the image MUST be binary (i.e. values of 0 and 1)
	for(i = 0; i < IMG_SIZE; i++) {
		data.u8TempImage[INDEX0][i] = data.u8TempImage[THRESHOLD][i] ? 1 : 0;
	}

	//wrap image INDEX0 in picture struct
	Pic.data = data.u8TempImage[INDEX0];
	Pic.width = nc;
	Pic.height = nr;
	Pic.type = OSC_PICTURE_BINARY;

	//now do region labeling and feature extraction
	OscVisLabelBinary( &Pic, &ImgRegions);
	OscVisGetRegionProperties( &ImgRegions);
}


void ClusterAngles() {
	int o, c;

	memset(data.u8TempImage[BACKGROUND], 0, IMG_SIZE);

	for(o = 0; o < ImgRegions.noOfObjects; o++) {
		//short cut for box's height and width
		int BoxHeight = ImgRegions.objects[o].bboxBottom-ImgRegions.objects[o].bboxTop;
		int BoxWidth = ImgRegions.objects[o].bboxRight-ImgRegions.objects[o].bboxLeft;
		//only treat objects above the minimum size
		if((ImgRegions.objects[o].area > MinArea) && (ImgRegions.objects[o].area < MaxArea)) {
			//a vision region is a connected horizontal block [startColumn endColumn] at the given row
			struct OSC_VIS_REGIONS_RUN* currentRun = ImgRegions.objects[o].root;

			do {
				for(c = currentRun->startColumn; c <= currentRun->endColumn; c++) {
					int r = currentRun->row;
					double angle = atan2(imgDy[r*nc+c], imgDx[r*nc+c]);
					double angleD = 2.*M_PI/NumAngleBins;

					//angle binning
					int dir = ((int) ((angle/angleD)+0.5))%NumAngleBins;

					/***************************************/
					/* here implement binning in 6 regions */
					/* and construction of feature vector  */
					/***************************************/

					//for visualization in BACKGROUND image
					data.u8TempImage[BACKGROUND][r*nc+c] = (uint8) (255.*(1+dir)/NumAngleBins);
				}
				currentRun = currentRun->next;
			} while(currentRun != NULL);

			/*******************************************/
			/* here implement normalization of feature */
			/* vector and determination of best match  */
			/*******************************************/

			//output result
			char outText[2];              /****************************************/
			outText[0] = Characters[o%26];/* replace example output by best match */
			outText[1] = 0;               /****************************************/

			DrawString(ImgRegions.objects[o].centroidX, ImgRegions.objects[o].bboxBottom, 2, LARGE, GREEN, outText);

			//OscLog(INFO, "(x,y)=(%d,%d)\n", len, binMax);
		}
	}
}


void DrawBoundingBoxes() {
	uint16 o;
	for(o = 0; o < ImgRegions.noOfObjects; o++) {
		if((ImgRegions.objects[o].area > MinArea) && (ImgRegions.objects[o].area < MaxArea)) {
			DrawBoundingBox(ImgRegions.objects[o].bboxLeft, ImgRegions.objects[o].bboxTop,
							ImgRegions.objects[o].bboxRight, ImgRegions.objects[o].bboxBottom, false, GREEN);
		}
	}
}
