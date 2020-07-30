/*********************************************************************/        
/* SELECT ELEMENT_RACUNA                                             */        
/*  PROVIZIJA, KI JO ZARA?UNAMO OB NAKUPU Z MAGNA KARTICO (535,524)  */        
/*             (POSLOVNE STORITVE)                         737       */        
/*             (STROŠKI TUJIH PLA?ILNIH KARTIC)                      */           
/*********************************************************************/        

select  sum(QTY) ZNESEK_V_DOMACI_VALUTI,
        profit_center,
        sum(QTY_M) QTY_M
--        sum(PRODAJNA_CENA) PRODAJNA_CENA,
--        sum(nvl(D096ZNP, 0)) ZNESEK_POPUSTA
from (
        SELECT                                         
        --       D095TER,CASE :BFIRMA WHEN 9110 THEN 202 ELSE :BFIRMA END,             
                 D095TER COMPANY,
                 CASE d095ter WHEN 9110 THEN 202 ELSE 12 END PROFIT_CENTER,             
                 D096TIP,D096BLS  PRODUCT,
                 'KT','KAR-PROV  ',                                                         
                 D095DOO ACCOUNTING_DATE ,
                 D096ZND QTY, 
                 D096KOL QTY_M,
                 D096CEN PRODAJNA_CENA,
                 D096ZNP,
                 D095OBV CUSTOMER,                                                        
                 D096UID,
                 D095DZS               
           FROM  PROD.RACUN,                                                           
                 PROD.ELEMENT_RACUNA    
                 
        -------------------------------------------------      
                        ,PROD.SIFRINT SIF 
        ---------------------------------------------------           
                 
                                                                
           WHERE D095DOO BETWEEN '1.1.2019' AND '31.1.2019'
           and   d095ter = 9110               
                                                          
           AND   D095VRA IN ('ND','LP')                                                 
           AND   D095KLJ = D096KRA                                                     
           AND   D096TIP = 'ST'                                                        
           AND   D096BLS = 1245
           
           
        -----------------------------------------------------------------   
          and SIF.D801OUT = d095ter  --D057KN2
          AND SIF.D801SFR = 'FBO'  
        --  AND   D095TER = 9110  --:BFIRMA   ---company     
        -------------------------------------------------------------------   
 ) x 
group by profit_center    


   
   
