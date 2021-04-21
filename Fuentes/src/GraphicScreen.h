// GraphicScreen.h: interface for the GraphicScreen class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GRAPHICSCREEN_H__38BFDE49_C26C_424A_993C_780780AB20F6__INCLUDED_)
#define AFX_GRAPHICSCREEN_H__38BFDE49_C26C_424A_993C_780780AB20F6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#include "stdafx.h"
#include "mytypes.h"

class GraphicScreen  
{
public:
	GraphicScreen(int aWidth, int aHeight, int aPxlSize, CDC* pDC);
	virtual ~GraphicScreen();
	void Update(WORD32* rawPixels);
	void PaintToDC(CDC* pCd, int x, int y);
	void InitScreen();
protected:
	int width;
	int height;
	int pxlSize;
	WORD32* pixels;

	CBitmap bmp, *pOldBitmap;
	CDC dcMem;
	CPen pen, *pOldPen;

	
	void CreateBitmap(int aWidth, int aHeight, int aPxlSize, CDC* pDC);
	void ReleaseBitmap();
};

#endif // !defined(AFX_GRAPHICSCREEN_H__38BFDE49_C26C_424A_993C_780780AB20F6__INCLUDED_)
