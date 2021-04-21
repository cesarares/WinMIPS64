// GraphicScreen.cpp: implementation of the GraphicScreen class.
//
//////////////////////////////////////////////////////////////////////

#include "GraphicScreen.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

GraphicScreen::GraphicScreen(int aWidth, int aHeight, int aPxlSize, CDC* pDC)
{
	pixels = NULL;
	CreateBitmap(aWidth, aHeight, aPxlSize, pDC);

}

GraphicScreen::~GraphicScreen()
{
	ReleaseBitmap();

}

void GraphicScreen::Update(WORD32* rawPixels){
	int i, x, y;
	CRect r;	

	
	for (i=0;i<width*height;i++){
			if (rawPixels[i]!=pixels[i])
			{
				pixels[i] = rawPixels[i];
				CBrush brush(pixels[i]);
				
	
				dcMem.SelectObject(brush);
				x=i%width; y=i/width; y=height-1-y;
				
				//dcMem.Rectangle(0+pxlSize*x,0+pxlSize*y,0+pxlSize*x+(pxlSize+1),0+pxlSize*y+(pxlSize+1));
				r.SetRect(pxlSize*x+1,0+pxlSize*y+1,pxlSize*x+(pxlSize),0+pxlSize*y+(pxlSize));
				dcMem.FillRect(r, &brush);

				//dcMem.Rectangle(0+pxlSize*x,0+pxlSize*y,0+pxlSize*x+(pxlSize+1),0+pxlSize*y+(pxlSize+1));

			}
		}
	  
		

}

void GraphicScreen::InitScreen(){
		int i;
		CRect rect;

		dcMem.FillRect(rect,WHITE_BRUSH);
		//dcMem.Rectangle(x_off, y_off, x_off+size+1, x_off+size+1);
		dcMem.Rectangle(0, 0, width+1, height+1);
		
		for (i=0;i<height*pxlSize;i+=pxlSize)
		{
			dcMem.MoveTo(0,0+i);
			dcMem.LineTo(0+width*pxlSize,0+i);
		}
		for (i=0;i<width*pxlSize;i+=pxlSize)
		{
			dcMem.MoveTo(0+i,0);
			dcMem.LineTo(0+i,0+height*pxlSize);
		}
		

}

void GraphicScreen::PaintToDC(CDC* pDC, int x, int y){
		pDC->BitBlt(x, x, width*pxlSize+1, height*pxlSize+1, &dcMem, 0, 0, SRCCOPY);

}

void GraphicScreen::CreateBitmap(int aWidth, int aHeight, int aPxlSize, CDC* pDC){
	
	ReleaseBitmap();

	width = aWidth;
	height= aHeight;
	pxlSize = aPxlSize;
	
	pixels=new WORD32[width*height];


	bmp.CreateCompatibleBitmap(pDC, width*pxlSize+1, height*pxlSize+1);

	
		char txt[80];
		sprintf(txt,"%d",width);
	//	AfxMessageBox(txt);	

	dcMem.CreateCompatibleDC(pDC);
	// Select the bitmap into the in-memory DC
	pOldBitmap = dcMem.SelectObject(&bmp);

	//CreatePen(PS_SOLID, 1, LGREY);




}

void GraphicScreen::ReleaseBitmap(){
	
	if (pixels!=NULL){
		delete pixels;
		dcMem.SelectObject(pOldBitmap);
		bmp.DeleteObject();
		dcMem.DeleteDC();

	}
}