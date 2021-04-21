// IOView.cpp : implementation file
//

#include "stdafx.h"
#include "wineve.h"
#include "IOView.h"
#include "MainFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CIOView

IMPLEMENT_DYNCREATE(CIOView, CScrollView)

CIOView::CIOView() :  m_ViewCharSize(0,0)
{
   m_pFont = NULL;
   m_pPen = NULL;
   m_pGraphicScreen = NULL;
   nlines=0;
   line="";
   caretcount=0;
}

CIOView::~CIOView()
{
}


BEGIN_MESSAGE_MAP(CIOView, CScrollView)
	//{{AFX_MSG_MAP(CIOView)
	ON_WM_CHAR()
	ON_WM_SETFOCUS()
	ON_WM_ERASEBKGND()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CIOView drawing


void CIOView::OnInitialUpdate()
{
	CScrollView::OnInitialUpdate();

//	CSize sizeTotal;
	// TODO: calculate the total size of this view
//	sizeTotal.cx = sizeTotal.cy = 32;
//	SetScrollSizes(MM_TEXT, sizeTotal);
	ComputeViewMetrics();
	
//	font.CreateFont(15,0,0,0,400,FALSE,FALSE,0,
//					ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,
//					DEFAULT_QUALITY,DEFAULT_PITCH|FF_MODERN,"Courier New");
}


CFont*	CIOView::GetFont()
{
	if (m_pFont == NULL)
	{  
		m_pFont = new CFont;
		if(m_pFont)
		{
			m_pFont->CreatePointFont(90, "Courier New");
		}
	}
	return m_pFont;
}\

/*
CPen*	CIOView::GetPen()
{
	if (m_pPen == NULL)
	{  
		m_pPen = new CPen;
		if(m_pPen)
		{
			m_pPen->CreatePen(PS_SOLID, 1, LGREY);
		}
	}
	return m_pPen;
}
*/

GraphicScreen* CIOView::GetGraphicScreen(CDC* pDC){
	if (m_pGraphicScreen == NULL)
	{  

		m_pGraphicScreen = new GraphicScreen(GSXY, GSXY, GSPXLSIZE, pDC);

	}
	return m_pGraphicScreen;

}
void CIOView::ComputeViewMetrics()
{	 
	CDC* pDC = CDC::FromHandle(::GetDC(NULL));  
	int nSaveDC = pDC->SaveDC();      
	pDC->SetMapMode(MM_TEXT);     
	CFont* pPreviousFont = pDC->SelectObject(GetFont());  
	TEXTMETRIC tm;  
	pDC->GetTextMetrics(&tm);   
	m_ViewCharSize.cy = tm.tmHeight + tm.tmExternalLeading;  
	m_ViewCharSize.cx = tm.tmAveCharWidth;   
	pDC->LPtoDP(&m_ViewCharSize);  
/*
	CTextDoc* pDoc = GetDocument();  
	m_DocSize.cy = m_ViewCharSize.cy * pDoc->GetLineList()->GetCount();
    
	CString	Line;  
	CSize size;  
	POSITION pos = pDoc->GetLineList()->GetHeadPosition();  
	while( pos != NULL )  
	{	
		Line = pDoc->GetLineList()->GetNext( pos );	
		size = pDC->GetTextExtent(Line, Line.GetLength());	
		m_DocSize.cx = max(size.cx, m_DocSize.cx);  
	}  
	//	Account for our simple margin  
	m_DocSize.cx += 4 * m_ViewCharSize.cx;    
	// clean up  
*/
	if(pPreviousFont)  
	{	
		pDC->SelectObject(pPreviousFont);
	}  
	pDC->RestoreDC(nSaveDC);
	::ReleaseDC(NULL,pDC->GetSafeHdc());
}




void CIOView::OnDraw(CDC* pDC)
{
	CWinEVEDoc* pDoc = GetDocument();
	int cursor_y;
	CSize CharSize = GetCharSize();
	CFont* pPreviousFont = pDC->SelectObject(GetFont());
	//CPen* pPreviousPen= pDC->SelectObject(GetPen());
	CString line;
	CString string=pDoc->cpu.Terminal;
	CPoint ps;

	int beg,cr;
	
//	BOOL drawit=FALSE;

//pDoc->cpu.screen[871]=YELLOW;

//	for (i=0;i<1024;i++) if (pDoc->cpu.screen[i]!=WHITE) {drawit=TRUE;break;} 

	if (pDoc->cpu.drawit)
	{
		GraphicScreen* gs = GetGraphicScreen(pDC);
		gs->Update(pDoc->cpu.screen);
		gs->PaintToDC(pDC, GS_OFFX, GS_OFFY);
		return ;
	}




	beg=0; cursor_y=0;
	for(;;)
	{
		cr=string.Find('\n',beg);
		if (cr<0)
		{
			line=string.Mid(beg,string.GetLength());
			pDC->TextOut(0,cursor_y,line);
			break;
		}

		line=string.Mid(beg,cr-beg);
		pDC->TextOut(0,cursor_y,line);

		beg=cr+1;
		cursor_y+=CharSize.cy;
	}
 
	if(pPreviousFont)  
	{	
		pDC->SelectObject(pPreviousFont);  
	}

/*	if(pPreviousPen)  
	{	
		pDC->SelectObject(pPreviousPen);  
	}
*/
	// Scroll if no graphics displayed
	
	if (!pDoc->cpu.drawit && pDoc->cpu.nlines!=nlines)
	{
		BOOL change;
		int rows,start_row,nl=pDoc->cpu.nlines;
		ps=GetScrollPosition();

		start_row=ps.y/CharSize.cy;
		CRect sz;
		GetClientRect(&sz);
		rows=sz.Height()/CharSize.cy;
		change=FALSE;
		if (nl>start_row+rows)
		{
			change=TRUE;
			ps.y=(nl-rows)*CharSize.cy;
						
		}
		if (change) ScrollToPosition(ps);
	}

	nlines=pDoc->cpu.nlines;

	if (pDoc->cpu.keyboard==1)
	{
		ps.x=(pDoc->cpu.ncols)*CharSize.cx;
		ps.y=(pDoc->cpu.nlines+1)*CharSize.cy; 
		SetCaretPos (ps);
		
		if (caretcount==0) 
		{
			ShowCaret();
			caretcount=1;
		}

//		char txt[80];
//		sprintf(txt,"%d",caretcount);
//		AfxMessageBox(txt);	

	}
//	else HideCaret();

}



BOOL CIOView::OnEraseBkgnd(CDC* pDC) 
{
 // TODO: Add your message handler code here and/or call default
/*	 static i = 0;
	 i++;
	 char txt[80];
	sprintf(txt,"%d",i);
	AfxMessageBox(txt);	
	*/
	CWinEVEDoc* pDoc = GetDocument();
	if (pDoc->cpu.drawit) { // graphic mode, erase everything but bitmap screen area
		CRect br,dr;
		
		
		this->GetClientRect(&br);
		// erase top block
		dr.SetRect(br.left, br.top, br.right+1, GS_OFFY);
		pDC->FillRect(dr, WHITE_BRUSH);
		// erase bottom block
		dr.SetRect(br.left, GS_OFFY+GSXYSIZE, br.right+1, br.bottom);
		pDC->FillRect(dr, WHITE_BRUSH);
		// erase left block
		dr.SetRect(br.left, br.top+GS_OFFY, br.left+GS_OFFX, br.top+GS_OFFY+GSXYSIZE);
		pDC->FillRect(dr, WHITE_BRUSH);
		// erase right block
		dr.SetRect(br.left+GS_OFFX+GSXYSIZE, br.top+GS_OFFY, br.right, br.top+GS_OFFY+GSXYSIZE);
		pDC->FillRect(dr, WHITE_BRUSH);
		
	

		return TRUE;
	}
	return CView::OnEraseBkgnd(pDC);   
}

/////////////////////////////////////////////////////////////////////////////
// CIOView diagnostics

#ifdef _DEBUG
void CIOView::AssertValid() const
{
	CScrollView::AssertValid();
}

void CIOView::Dump(CDumpContext& dc) const
{
	CScrollView::Dump(dc);
}

CWinEVEDoc* CIOView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CWinEVEDoc)));
	return (CWinEVEDoc*)m_pDocument;
}


#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CIOView message handlers

void CIOView::OnPrepareDC(CDC* pDC, CPrintInfo* pInfo) 
{
	// TODO: Add your specialized code here and/or call the base class
//	CRect rectClient;
	// TODO: Add your specialized code here and/or call the base class
	
//	CView::OnPrepareDC(pDC, pInfo);

//	GetClientRect(rectClient);
//	pDC->SetMapMode(MM_ANISOTROPIC);
//	pDC->SetWindowExt(1000,1000);
//	pDC->SetViewportExt(rectClient.right,-rectClient.bottom/2);
//	pDC->SetViewportOrg(rectClient.right/2,rectClient.bottom/2);
//	pDC->SetBkMode(TRANSPARENT);
//	pDC->SelectObject(&font);	
	CScrollView::OnPrepareDC(pDC, pInfo);
}

void CIOView::OnUpdate(CView* /* pSender */, LPARAM /* lHint */, CObject* /* pHint */) 
{
	// TODO: Add your specialized code here and/or call the base class

	//ShowWindow(SW_SHOWNORMAL );
	CWinEVEDoc* pDoc = GetDocument();
	CSize sizeTotal;
	CSize CharSize = GetCharSize();

	sizeTotal.cx = 80*CharSize.cx;
	sizeTotal.cy = (pDoc->cpu.nlines+1)*CharSize.cy;
	SetScrollSizes(MM_TEXT, sizeTotal,CSize(100,56),CSize(100,14));

	if (pDoc->cpu.keyboard==0 && caretcount==1) 
	{
		HideCaret();
		caretcount=0;
	}

	InvalidateRect(NULL);




	
}

void CIOView::OnChar(UINT nChar, UINT nRepCnt, UINT nFlags) 
{

//	char txt[20];
	CWinEVEDoc* pDoc = GetDocument();
	CSize CharSize=GetCharSize();
	CPoint point;
	DOUBLE64 number;
	CMainFrame* pFrame=(CMainFrame*) AfxGetApp()->m_pMainWnd;
	CStatusBar* pStatus=&pFrame->m_wndStatusBar;
	/*char txt[80];
		sprintf(txt,"Antes %d",pDoc->cpu.lstChr);
		AfxMessageBox(txt);
	*/
	if (pDoc->cpu.keyboard==0)
	{ // just take one character, do not echo it, don't block if no char
		
		pDoc->cpu.lstChr = nChar;	
	
		/*sprintf(txt,"Despues %d",pDoc->cpu.lstChr);
		AfxMessageBox(txt);*/

	} 

	if (pDoc->cpu.keyboard==2)
	{ // just take one character, do not echo it.

		pDoc->cpu.mm[8] = (BYTE) nChar;
		pDoc->cpu.keyboard=0;
		pStatus->SetPaneText(0,"Ready");
		if (pDoc->restart) OnCommand(ID_EXECUTE_RUNTO,0);
	}

	if (pDoc->cpu.keyboard==1)
	{
//		char txt[80];
//		sprintf(txt,"%d",nChar);
//		AfxMessageBox(txt);
	
		point.x=(pDoc->cpu.ncols+1)*CharSize.cx;
		point.y=(pDoc->cpu.nlines+1)*CharSize.cy;
   
		SetCaretPos (point);

		if (nChar==13)
		{
			if (caretcount==1)
			{
				HideCaret();
				caretcount=0;
			}
			if (line.Find('.')>=0)
				number.d=atof(line);
			else
				number.s=_atoi64(line);
			*(WORD64 *)&(pDoc->cpu.mm[8]) = number.u; 
			line="";
			pDoc->cpu.Terminal+='\n';
			pDoc->cpu.keyboard=0;
			pStatus->SetPaneText(0,"Ready");
			if (pDoc->restart) OnCommand(ID_EXECUTE_RUNTO,0);
		}
		else 
		{

			if (nChar==8) 
			{
				if (line.GetLength()>0)
				{
					line.Delete(line.GetLength()-1);
					pDoc->cpu.Terminal.Delete(pDoc->cpu.Terminal.GetLength()-1);
					pDoc->cpu.ncols--;
				}

			}
			else
			{
				line+= (BYTE) nChar;
				pDoc->cpu.Terminal+= (BYTE) nChar;
				pDoc->cpu.ncols++;
			}
			if (caretcount==1)
			{
				HideCaret();
				caretcount=0;
			}

			InvalidateRect(NULL);
		}
	}

	CScrollView::OnChar(nChar, nRepCnt, nFlags);
}

void CIOView::OnSetFocus(CWnd* pOldWnd) 
{
	CWinEVEDoc* pDoc = GetDocument();
	CScrollView::OnSetFocus(pOldWnd);
	CreateSolidCaret (10, 2);
	caretcount=0;
	if (pDoc->cpu.keyboard==1)
	{
		ShowCaret();
		caretcount=1;
	}
}
