// ChildFrm.cpp : implementation of the CChildFrame class
//

#include "stdafx.h"
#include "WinEVE.h"

#include "ChildFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CChildFrame

IMPLEMENT_DYNCREATE(CChildFrame, CMDIChildWnd)

BEGIN_MESSAGE_MAP(CChildFrame, CMDIChildWnd)
	//{{AFX_MSG_MAP(CChildFrame)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CChildFrame construction/destruction

CChildFrame::CChildFrame()
{
	// TODO: add member initialization code here
	
}

CChildFrame::~CChildFrame()
{
}

static char *codetit="Code";

BOOL CChildFrame::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs
	cs.style=WS_OVERLAPPEDWINDOW|WS_CHILD|WS_MAXIMIZE;
	cs.lpszName=codetit;

	return CMDIChildWnd::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CChildFrame diagnostics

#ifdef _DEBUG
void CChildFrame::AssertValid() const
{
	CMDIChildWnd::AssertValid();
}

void CChildFrame::Dump(CDumpContext& dc) const
{
	CMDIChildWnd::Dump(dc);
}

#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CChildFrame message handlers

void CChildFrame::ActivateFrame(int nCmdShow) 
{
	// TODO: Add your specialized code here and/or call the base class
	CMenu *pSysMenu=GetSystemMenu(FALSE);
	pSysMenu->EnableMenuItem(6,MF_BYPOSITION|MF_GRAYED);
	SetIcon(LoadIcon(AfxGetInstanceHandle(),MAKEINTRESOURCE(IDI_ICON6)),TRUE);	
	CMDIChildWnd::ActivateFrame(nCmdShow);
}
