function [M]=DATCOM_TO_MVO_RDX2021(dados,for005)
% RODAR O  DATCOM  PARA A MVO E EXTRAINDO OS DADOS DELE.
% Gera a struct M

% montanha de FOR'S.

for icg = 1:length(dados.cg)
    for iphif0 = 1:length(dados.phif)
          for005.REFQ.XCG = dados.cg(icg);
          if for005.FINSET2.has==1
            for005.FINSET2.AngleSET = [mod(45+dados.phif(iphif0),360),mod(135+dados.phif(iphif0),360),mod(225+dados.phif(iphif0),360),mod(315+dados.phif(iphif0),360)];
          end
          if for005.FINSET1.has==1
            for005.FINSET1.AngleSET = [mod(45+dados.phif(iphif0),360),mod(135+dados.phif(iphif0),360),mod(225+dados.phif(iphif0),360),mod(315+dados.phif(iphif0),360)];
          end
                        
          gera_for005(for005)
          !Misdat.exe
           % quando considera FINSET1.LER
           % resolver o run-time error M6201: MATH  - sqrt: DOMAIN error
           % Image              PC        Routine            Line        Source
           % Misdat.exe         0050D539  Unknown               Unknown  Unknown
           %[CN,CM,CA,CY,CLN,CLL,CD,CNQ, CMQ, CAQ, CNAD, CMAD, CYR, CLNR, CLLR, ...
           %    CYP,CLNP,CLLP]=DATCOMreader_nathy_reduzido('for006.dat',for005.FINSET1,for005.FINSET2,dados); % na dinâmica só usa esses coeficientes
           [CN,CM,CA,CY,CLN,CLL,CL,CD,XCP,CNA,CMA,CYB,CLNB,CLLB,CNQ, CMQ, CAQ, ...
               CNAD, CMAD, CYR, CLNR, CLLR, CYP, CLNP ,CLLP, hinge]=DATCOMreader_nathy('for006.dat',for005.FINSET1,for005.FINSET2,dados);
           % Seguindo a ordem das dimensões nas extracoes dos dados.
           % -------------------------
           % DELTAS ; PHI ; MACH ; ALPHA ; XCG
           % -------------------------
                        
           % Para cada uma das condicoes de DELTAS, PHI e XCG,
           % rodar e guardar nessa MATRIZ de 8 dimensoes.
           for imach=1:length(dados.mach)
            for ialfa=1:length(dados.alpha)
                M.CN(iphif0,imach,ialfa,icg)=CN(ialfa,imach);
                M.CM(iphif0,imach,ialfa,icg)=CM(ialfa,imach);
                M.CA(iphif0,imach,ialfa,icg)=CA(ialfa,imach);
                M.CY(iphif0,imach,ialfa,icg)=CY(ialfa,imach);
                M.CLN(iphif0,imach,ialfa,icg)=CLN(ialfa,imach);
                M.CLL(iphif0,imach,ialfa,icg)=CLL(ialfa,imach);
                M.CD(iphif0,imach,ialfa,icg)=CD(ialfa,imach);
                M.CL(iphif0,imach,ialfa,icg)=CL(ialfa,imach);
                M.XCP(iphif0,imach,ialfa,icg)=XCP(ialfa,imach);
                M.CNA(iphif0,imach,ialfa,icg)=CNA(ialfa,imach);
                M.CMA(iphif0,imach,ialfa,icg)=CMA(ialfa,imach);
                M.CYB(iphif0,imach,ialfa,icg)=CYB(ialfa,imach);
                M.CLNB(iphif0,imach,ialfa,icg)=CLNB(ialfa,imach);
                M.CLLB(iphif0,imach,ialfa,icg)=CLLB(ialfa,imach);
                M.CNQ(iphif0,imach,ialfa,icg)=CNQ(ialfa,imach);
                M.CMQ(iphif0,imach,ialfa,icg)= CMQ(ialfa,imach);
                M.CAQ(iphif0,imach,ialfa,icg)=CAQ(ialfa,imach);
                M.CNAD(iphif0,imach,ialfa,icg)=CNAD(ialfa,imach);
                M.CMAD(iphif0,imach,ialfa,icg)=CMAD(ialfa,imach);
                M.CYR(iphif0,imach,ialfa,icg)=CYR(ialfa,imach);
                M.CLNR(iphif0,imach,ialfa,icg)=CLNR(ialfa,imach);
                M.CLLR(iphif0,imach,ialfa,icg)=CLLR(ialfa,imach);
                M.CYP(iphif0,imach,ialfa,icg)=CYP(ialfa,imach);
                M.CLNP(iphif0,imach,ialfa,icg)=CLNP(ialfa,imach);
                M.CLLP(iphif0,imach,ialfa,icg)=CLLP(ialfa,imach);
                M.hinge11(iphif0,imach,ialfa,icg)=hinge(1,1,ialfa,imach);
                M.hinge12(iphif0,imach,ialfa,icg)=hinge(1,2,ialfa,imach);
                M.hinge13(iphif0,imach,ialfa,icg)=hinge(1,3,ialfa,imach);
                M.hinge14(iphif0,imach,ialfa,icg)=hinge(1,4,ialfa,imach);
            end
        end
     end
  end
end