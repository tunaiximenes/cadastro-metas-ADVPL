#INCLUDE "PROTHEUS.CH"   
#Include "Rwmake.ch"
#Include "TOPCONN.ch"  

User Function TXM600()            

  Private cCadastro := "Cadastro de Metas ShowRoom / Recepcionistas" 
  Private aRotina   := MenuDef()    

  dbSelectArea("ZZ5")
  dbSetOrder(1)
  mBrowse(006,001,022,075,"ZZ5")
  dbSelectArea("ZZ5")
  dbClearFilter()
  dbSetOrder(1)

Return

User Function CadMetaSR(cAlias,nReg,nOpcX)

Local aArea		 := ZZ5->(GetArea())
Local aSizeAut	 := MsAdvSize(,.F.)   
Local aObjects	 := {}
Local aInfo 	 := {}      
Local aPosObj	 := {}
Local aNoFields  := {"ZZ5_LOCAL","ZZ5_ANOMES"}      
Local aYesFields := {"ZZ5_VEND","ZZ5_NOME","ZZ5_COTBAS","ZZ5_COTMAX","ZZ5_COTMIN","ZZ5_COTSPO","ZZ5_TIPO"}
Local cSeek      := ""
Local cWhile     := ""
Local nOpcA      := 0
Local nX         := 0
Local lGravaOK   := .T.
Local oDlg
Local oGetDados        
Local cZZ5local	 := Substr(sm0->m0_codfil,5,2)      
Local cZZ5anomes := mv_par01                 
Local oPnlMst      
Private nMetaAS := nMetaBS := nMetaCS := nMetaAR := nMetaBR := nMetaCR := nMetaA := nMetaB := nMetaC := 0 
Private nValorTA := nValorTB := nValorTC := 0
//Private cZZ5anomes := mv_par01 //ZZ5->ZZ5_ANOMES      
Private lZZ5Visual := .F.
Private lZZ5Inclui := .F.
Private lZZ5Deleta := .F.
Private lZZ5Altera := .F.

//Local bCond := {|| .t.}

Private aHeader := {}
Private aCols   := {}       
Private cPerg   := "TXM600"             

 
  If !pergunte(cPerg,.T.)
     Return(NIL)
  EndIf

//Public cZZ5anomes := 0
                                  
RegToMemory("ZZ5",.F.,.F.)  // Inicializa variaveis de memória

// Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  

If  aRotina[nOpcX][4] == 2
	lZZ5Visual := .T.
ElseIf aRotina[nOpcX][4] == 3
	lZZ5Inclui	:= .T.       
ElseIf aRotina[nOpcX][4] == 4
	lZZ5Altera	:= .T.
ElseIf aRotina[nOpcX][4] == 5
	lZZ5Deleta	:= .T.
	lZZ5Visual	:= .T.
EndIf    
                       
            

nMetaA := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METAA")
nMetaB := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METAB")
nMetaC := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METAC")      

nMetaAS := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METAAS")
nMetaBS := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METABS")
nMetaCS := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METACS")      

nMetaAR := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METAAR")
nMetaBR := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METABR")
nMetaCR := Posicione("ZZ0",1,xFilial("ZZ0") + substr(sm0->m0_codfil,5,2) + mv_par01,"ZZ0_METACR")      
                                   
//  Monta aHeader e aCols utilizando a funcao FillGetDados.  
If lZZ5Inclui
	     
	//cZZ5local  := CRIAVAR("ZZ5_LOCAL")
	cZZ5anomes := CRIAVAR("ZZ5_ANOMES")       
	cZZ5anomes := mv_par01
	
	If (nMetaA == 0 .or. nMetaB == 0 .or. nMetaC == 0)
	   Aviso("ATENÇÃO","Para incluir metas de vendedores, 1º precisa cadastrar metas de vendas das lojas.",{"OK"}) 
	   Return 
    EndIf

	// Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/) 
	FillGetDados(nOpcX,"ZZ5",1,,,,aNoFields,aYesFields,,,,.T.,,,)       
	  
Else

	If (mv_par01 <> ZZ5->ZZ5_ANOMES)
	   Aviso("ATENÇÃO","Não existe metas de vendedores no período '"+ mv_par01 + "' cadastradas, não é possível alterar.",{"OK"}) 
	   Return 
    EndIf
		
	cSeek   := xFilial("ZZ5") + ZZ5->ZZ5_LOCAL + ZZ5->ZZ5_ANOMES
	cWhile  := "ZZ5->ZZ5_FILIAL+ZZ5->ZZ5_LOCAL+ZZ5->ZZ5_ANOMES"
	//  Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/) |
	FillGetDados(nOpcX,"ZZ5",1,cSeek,{|| &cWhile },,aNoFields,aYesFields,,,,,,,)

EndIf  

AAdd( aObjects, { 000, 025, .T., .F. })
AAdd( aObjects, { 100, 100, .T., .T. })
aInfo  := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
aPosObj:= MsObjSize( aInfo, aObjects )

DEFINE MSDIALOG oDlg TITLE "CADASTRO DE METAS SHOWROOM / RECEPCIONISTAS" From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL	

	oPnlMst := tPanel():Create(oDlg, 0, 0,,,,,,/*CLR_RED*/,aSizeAut[5]-1,/*nHeight*/)    //0
	oPnlMst:Align := CONTROL_ALIGN_ALLCLIENT
	
	@ 024, 5 SAY   "Loja  "  OF oPnlMst PIXEL  
	@ 022, 50 MSGET cZZ5local  PICTURE PesqPict("ZZ5","ZZ5_LOCAL") OF oPnlMst PIXEL SIZE 30,10 RIGHT WHEN .F.
 
    @ 024,105 SAY OemToAnsi("AnoMes" ) SIZE 30,10 OF oPnlMst PIXEL                                 //010
    @ 022,150 MSGET cZZ5anomes Picture "999999" SIZE 40,8  OF oPnlMst PIXEL Valid When .F.         //008 

   	@ 001,330 Say "Meta A" OF oPnlMst PIXEL //Size 30,8  
	@ 010,250 Say "ShowRoom " OF oPnlMst PIXEL
	@ 008,300 MSGET nMetaAS PICTURE PesqPict("ZZ5","ZZ5_COTBAS") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F. 
   	@ 008,400 MSGET nMetaBS PICTURE PesqPict("ZZ5","ZZ5_COTMAX") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F. 
   	@ 008,500 MSGET nMetaCS PICTURE PesqPict("ZZ5","ZZ5_COTMIN") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F. 
    
    @ 001,430 Say "Meta B" OF oPnlMst PIXEL                                                               
	@ 024,250 Say "Recepção " OF oPnlMst PIXEL
	@ 022,300 MSGET nMetaAR PICTURE PesqPict("ZZ5","ZZ5_COTBAS") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F. 
   	@ 022,400 MSGET nMetaBR PICTURE PesqPict("ZZ5","ZZ5_COTMAX") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F. 
   	@ 022,500 MSGET nMetaCR PICTURE PesqPict("ZZ5","ZZ5_COTMIN") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F.   
   	                                                                                                      
    @ 001,530 Say "Meta C" OF oPnlMst PIXEL 
	@ 038,250 Say "Total " OF oPnlMst PIXEL
	@ 036,300 MSGET nMetaA PICTURE PesqPict("ZZ5","ZZ5_COTBAS") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F. 
   	@ 036,400 MSGET nMetaB PICTURE PesqPict("ZZ5","ZZ5_COTMAX") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F. 
   	@ 036,500 MSGET nMetaC PICTURE PesqPict("ZZ5","ZZ5_COTMIN") OF oPnlMst PIXEL SIZE 80,10 RIGHT WHEN .F.
    
	oGetDados := MSGetDados():New(aPosObj[2,1]+30,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcX,"U_AZZ5LinOK","U_AZZ5TudOK",,!lZZ5Altera)  //"+ZZ5_VEND"
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1, IIf(oGetdados:TudoOk(),(nOpcA := 1,oDlg:End()),nOpcA := 0)},{||oDlg:End()})

If nOpcA == 1	
	If lZZ5Inclui .Or. lZZ5Altera .Or. lZZ5Deleta
		lGravaOk := U_AZZ5Grava(cZZ5local,cZZ5anomes,lZZ5Deleta)

	    //If lGravaOk
		//EndIf  
		
	EndIf	
Endif

If nOpcA == 0 .And. lZZ5Inclui
   // abandona a inclusão de registros
EndIf

RestArea(aArea)
Return 

//  Critica se a linha digitada esta' Ok      

User Function AZZ5LinOk(o)

Local aArea	:= GetArea()
Local nPos       := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_VEND" })
Local nX         := 1
Local nZ         := 0                                    
Local nPos       := 0
Local lRet       := .T.
Local lDeleted   := .F.   
//Local cZZ5local	 := ZZ5->ZZ5_LOCAL 
//Local cZZ5anomes := mv_par01                                  
Local nPosMetaA  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTBAS"})
Local nPosMetaB  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMAX"})
Local nPosMetaC  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMIN"})
Local nPosVend   := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_VEND" })
Local nCodVend   := {} 
Local nCont      := 1         
Local lSub       := .F.   

If ValType(aCols[n,Len(aCols[n])]) == "L"   // Verifico se posso Deletar
	lDeleted := aCols[n,Len(aCols[n])]      // Se esta Deletado 
	aadd( nCodVend, aCols[n][nPosVend] )
		
EndIf

If lRet .And. !lDeleted     
   
	For nX := 1 to Len(aCols)                                               
	
	    If Empty(aCols[nX][nPosVend])
	       Aviso("ATENÇÃO","Falta informar código para vendedor ou recepcionista.",{"Corrigir"}) 
	       lRet := .F.
        EndIf     
        
        ZZ5->(dbSetOrder(1))
	    ZZ5->(Msseek(xFilial("ZZ5") + substr(sm0->m0_codfil,5,2) + mv_par01 + aCols[nX][nPosVend]))
		If (ZZ5->ZZ5_LOCAL == substr(sm0->m0_codfil,5,2)) .And. (ZZ5->ZZ5_ANOMES == mv_par01) .And. (ZZ5->ZZ5_VEND == aCols[nX][nPosVend]) .and. lZZ5Inclui 
			Aviso("ATENÇÃO","META JÝ CADASTRADA PARA ESTE VENDEDOR '"+ aCols[nX][nPosVend] + "' EM '"+ mv_par01 + "' " ,{"Corrigir"})
			lRet := .F.
			Exit
		EndIf

	Next Nx
 
				
	For nZ = 1 to Len(aCols)
       
       
	   If aCols[nz][nPosMetaA] < aCols[nz][nPosMetaB] 
	   	 Aviso("ATENÇÃO","Valor da meta (A < B), valor da Meta A tem que ser > do que B.",{"Corrigir"}) 
	     lRet := .F.
	   
	   ElseIf aCols[nz][nPosMetaB] > aCols[nz][nPosMetaA]  
	   	 Aviso("ATENÇÃO","Valor da meta (B > A), valor da Meta B tem que ser > do que A.",{"Corrigir"}) 
	     lRet := .F.
	   
	   ElseIf aCols[nz][nPosMetaA] < aCols[nz][nPosMetaC]  
	   	 Aviso("ATENÇÃO","Valor da meta (A < C), valor da Meta A tem que ser > do que C.",{"Corrigir"}) 
	     lRet := .F.
	   
	   ElseIf aCols[nz][nPosMetaC] > aCols[nz][nPosMetaA]  
	   	 Aviso("ATENÇÃO","Valor da meta (C > A), valor da Meta C tem que ser < do que A.",{"Corrigir"}) 
	     lRet := .F.
	   
	   ElseIf aCols[nz][nPosMetaC] > aCols[nz][nPosMetaB]  
	   	 Aviso("ATENÇÃO","Valor da meta (C > B), valor da Meta C tem que ser < do que B.",{"Corrigir"}) 
	     lRet := .F.
	   
	   Endif
	   
	Next nZ        


Endif


RestArea(aArea) 

Return lRet


// Critica se a nota toda esta' Ok            

User Function AZZ5TudOk(o) 

Local aArea     := GetArea()
Local nX        := 0    
Local lRet      := .T.
Local lDeleted  := .F.
Local lPE       := .T. 
Local lSub      := .F.                         
Local nPosTipo   := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_TIPO" })
Local nPosMetaA  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTBAS"})
Local nPosMetaB  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMAX"})
Local nPosMetaC  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMIN"})
Local nValorTA := nValorTB := nValorTC := 0
Local nValorTAS := nValorTBS := nValorTCS := 0
Local nValorTAR := nValorTBR := nValorTCR := 0

Local nPosMetaAS  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTBAS"})
Local nPosMetaBS  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMAX"})
Local nPosMetaCS  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMIN"})

Local nPosMetaAR  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTBAS"})
Local nPosMetaBR  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMAX"})
Local nPosMetaCR  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMIN"})
Local nPosVend    := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_VEND" })

Local nCodVend   := {} 
Local nCont := nCont1 := nCont2 := 1
                                                                      

For nX := 1 to Len(aCols)    

	If ValType(aCols[nX,Len(aCols[nX])]) == "L"
		lDeleted := aCols[nX,Len(aCols[nX])]      /// Se esta Deletado
	EndIf
     
    If lDeleted

       nValorTA := nValorTA - aCols[nX][nPosMetaA]
       nValorTB := nValorTB - aCols[nX][nPosMetaB]
       nValorTC := nValorTC - aCols[nX][nPosMetaC] 
       
       If aCols[nX][nPosTipo] == "VEN"                
    
          nValorTAS := nValorTAS - aCols[nX][nPosMetaA]
          nValorTBS := nValorTBS - aCols[nX][nPosMetaB]
          nValorTCS := nValorTCS - aCols[nX][nPosMetaC]
    
       ElseIf aCols[nX][nPosTipo] == "REC" 
    
          nValorTAR := nValorTAR - aCols[nX][nPosMetaA]
          nValorTBR := nValorTBR - aCols[nX][nPosMetaB]
          nValorTCR := nValorTCR - aCols[nX][nPosMetaC]                      
    
       EndIf

    EndIf

    nValorTA := nValorTA + aCols[nX][nPosMetaA]
    nValorTB := nValorTB + aCols[nX][nPosMetaB]
    nValorTC := nValorTC + aCols[nX][nPosMetaC] 
    
    //alert(aCols[nX][nPosTipo])
    
    If aCols[nX][nPosTipo] == "VEN"                

       nValorTAS := nValorTAS + aCols[nX][nPosMetaA]
       nValorTBS := nValorTBS + aCols[nX][nPosMetaB]
       nValorTCS := nValorTCS + aCols[nX][nPosMetaC]
    
    ElseIf aCols[nX][nPosTipo] == "REC" 
    
       nValorTAR := nValorTAR + aCols[nX][nPosMetaA]
       nValorTBR := nValorTBR + aCols[nX][nPosMetaB]
       nValorTCR := nValorTCR + aCols[nX][nPosMetaC]                      
    
    EndIf
    
	aadd( nCodVend, aCols[nX][nPosVend] )

Next nX
                  


If nValorTAS <> nMetaAS 
   Aviso("ATENÇÃO","A soma total das metas A ShowRoom '" + Str(nValorTAS,16,2) + "', difere do valor da Meta A ShowRoom '"+ Str(nMetaAS,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F.  
  	   
ElseIf nValorTBS <> nMetaBS 
   Aviso("ATENÇÃO","A soma total das metas B ShowRoom '" + Str(nValorTBS,16,2) + "', difere do valor da Meta B ShowRoom '"+ Str(nMetaBS,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F. 
	   
ElseIf nValorTCS <> nMetaCS 
   Aviso("ATENÇÃO","A soma total das metas C ShowRoom '" + Str(nValorTCS,16,2) + "', difere do valor da Meta C ShowRoom '"+ Str(nMetaCS,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F. 
	     
Endif 
                          
//Valida valores Recepcionistas

If nValorTAR <> nMetaAR 
   Aviso("ATENÇÃO","A soma total das metas A Recepção '" + Str(nValorTAR,16,2) + "', difere do valor da Meta A Recepção '"+ Str(nMetaAR,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F.  
	   
ElseIf nValorTBR <> nMetaBR 
   Aviso("ATENÇÃO","A soma total das metas B Recepção '" + Str(nValorTBR,16,2) + "', difere do valor da Meta B Recepção '"+ Str(nMetaBR,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F. 
	   
ElseIf nValorTCR <> nMetaCR 
   Aviso("ATENÇÃO","A soma total das metas C Recepção '" + Str(nValorTCR,16,2) + "', difere do valor da Meta C Recepção '"+ Str(nMetaCR,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F. 
	     
Endif 

// Valida valores totais

If nValorTA <> nMetaA 
   Aviso("ATENÇÃO","A soma total das metas A '" + Str(nValorTA,16,2) + "', difere do valor da Meta A '"+ Str(nMetaA,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F.  
	   
ElseIf nValorTB <> nMetaB 
   Aviso("ATENÇÃO","A soma total das metas B '" + Str(nValorTB,16,2) + "', difere do valor da Meta B '"+ Str(nMetaB,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F. 
	   
ElseIf nValorTC <> nMetaC 
   Aviso("ATENÇÃO","A soma total das metas C '" + Str(nValorTC,16,2) + "', difere do valor da Meta C '"+ Str(nMetaC,16,2) + "' da loja.",{"Corrigir"}) 
   lRet := .F. 
	     
Endif            


//Next

RestArea(aArea)
Return lRet

                
// Funcao de gravacao de metas showroom / recepcionistas.                

User Function AZZ5Grava(cZZ5local,cZZ5anomes,lZZ5Deleta)          

Local nPosVend  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_VEND"})
Local nPosMetaA := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTBAS"})
Local nPosMetaB := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMAX"})
Local nPosMetaC := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ5_COTMIN"})
Local nX        := 0
Local ny        := 0   
Local lRet      := .T.
Local lMTZZ5VLD := .F.

If lRet

	Begin Transaction		
	dbSelectArea("ZZ5") 
	dbSetOrder(1)
    	
	For nX = 1 to Len(aCols)		 
	                                                                           
		If dbSeek(xFilial("ZZ5") + substr(sm0->m0_codfil,5,2) + mv_par01 + aCols[nx][nPosVend] )
			RecLock("ZZ5",.F.)
		Else       
			RecLock("ZZ5",.T.)          			      
		EndIf			                
		
		If !lZZ5Deleta
  
			If !aCols[nX,Len(aCols[nX])]
 
	   		    // Atualiza dados da GetDados                     
				For nY := 1 to Len(aHeader)
					If ( aHeader[nY][10] <> "V" )
						ZZ5->(FieldPut(FieldPos(Trim(aHeader[nY][2])),aCols[nX][nY]))
					EndIf          
					                                                  
			   		ZZ5->(FieldPut(FieldPos(Trim(aHeader[nY][2])),aCols[nX][nY])) 
				
				Next nY
				
				// Atualiza os Campos do Cabecalho                 
				ZZ5->ZZ5_FILIAL	:= xFilial("ZZ5")
				ZZ5->ZZ5_LOCAL	:= substr(sm0->m0_codfil,5,2)   //cZZ5local
				ZZ5->ZZ5_ANOMES	:= mv_par01         //cZZ5anomes            
					
			Else
				dbDelete()
			EndIf
		
		Else
			dbDelete()
		EndIf 
		
	Next nX	
	
	ZZ5->(MsUnLock())	
	End Transaction
		
EndIf
Return .T. 

Static Function MenuDef()     
Private aRotina	:=     {{OemToAnsi("Pesquisar") ,"AxPesqui",0,1,0,.F.},;	 
 						{OemToAnsi("Visualizar"),"U_CadMetaSR",0,2,0,nil},; 
						{OemToAnsi("Incluir")   ,"U_CadMetaSR",0,3,0,nil},; 
						{OemToAnsi("Alterar")   ,"U_CadMetaSR",0,4,0,nil},; 
						{OemToAnsi("Excluir")   ,"U_CadMetaSR",0,5,0,nil} } 	
Return(aRotina)           
                    


