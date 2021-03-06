USE DATABASE DWH_prod;
USE SCHEMA APLsdb;



SELECT  
	CO.COMPANY_CODE_PIS
	,CO.COMPANY_CODE
	,CO.NAME COMPANY_NAME
--	,T.ACCOUNTING_DATE_SID
        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN T.ACCOUNTING_DATE_SID  ELSE T.ACCOUNTING_DATE_SID + 10000 END  ACCOUNTING_DATE_sid        
 --popravek 6.4.                 
--        ,dat.ext_refr ACCOUNTING_DATE 
--        ,dateadd(month, 12, to_date(dat.ext_refr)) ACCOUNTING_DATE        
        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN dat.ext_refr  ELSE dateadd(month, 12, to_date(dat.date)) END  ACCOUNTING_DATE         
 --popravek 6.4.	
	--        ,TO_DATE(TO_CHAR(DAT.MONTH_ID*100+1))    ACCOUNTING_DATE 
	--        ,DATX.DATE ACCOUNTING_DATE 
	,T44.PROFIT_CENTER_EXT_REFR 
	,T44.PROFIT_CENTER_NAME
	,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 1 ELSE 2 END) AS CUSTOMER_TYPE_CODE
	,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 'B2C' ELSE 'B2B' END) AS CUSTOMER_TYPE
	,T.IS_OWN_USAGE
	, CASE WHEN PM.PAYMENT_METHOD_SID = -1 THEN 'N/A'
	        WHEN PM.LEVEL02_CODE = 'GOTOVINA'                          THEN 'Gotovina'                   
	        WHEN PM.LEVEL04_CODE = 'BAN?NE KARTICE'                    THEN 'Ban?ne kartice'             
---- novo 3.4.--------------------------                
                when pm.LEVEL04_CODE in ('M - PETROL PLA�ILNE KARTICE', 'M - Petrol pla�ilne kartice')       then 'Petrol pla�ilne kartice'                            
--                when pm.LEVEL04_CODE = 'M - PETROL PLAČILNE KARTICE'       then 'Petrol pla�?ilne kartice'
---- novo 3.4.--------------------------                

	        WHEN PM.LEVEL04_CODE = 'PETROLOVE POSLOVNE KARTICE'        THEN 'Petrolove poslovne kartice' 
	        WHEN PM.LEVEL04_CODE = 'TUJE KAMIONSKE KARTICE'            THEN 'Tuje kamionske kartice'     
	        ELSE 'Other' END AS PAYMENT_METHOD    
    ,PR.PRODUCT_CODE 
    ,PR.PRODUCT_NAME_SHORT
    ,T44.LEVEL01_EXT_REFR PC_LEVEL01_EXT_REFR        
    ,T44.LEVEL02_EXT_REFR PC_LEVEL02_EXT_REFR     
    ,T44.LEVEL03_EXT_REFR PC_LEVEL03_EXT_REFR        
    , T44.LEVEL04_EXT_REFR PC_LEVEL04_EXT_REFR
    ,T44.LEVEL05_EXT_REFR PC_LEVEL05_EXT_REFR        
    ,T44.LEVEL06_EXT_REFR PC_LEVEL06_EXT_REFR      
    ,T44.LEVEL07_EXT_REFR PC_LEVEL07_EXT_REFR         
    ,T44.LEVEL08_EXT_REFR PC_LEVEL08_EXT_REFR
    ,T44.LEVEL09_EXT_REFR PC_LEVEL09_EXT_REFR        
    ,T44.LEVEL10_EXT_REFR PC_LEVEL10_EXT_REFR
    ,T44.LEVEL01_CODE PCL1       
    ,T44.LEVEL01_NAME PC_L1_NAME 
    ,T44.LEVEL02_CODE PC_L2      
    , T44.LEVEL02_NAME PC_L2_NAME      
    ,T44.LEVEL03_CODE PC_L3        
    ,T44.LEVEL03_NAME PC_L3_NAME        
    ,T44.LEVEL04_CODE PC_L4      
    ,T44.LEVEL04_NAME PC_L4_NAME 
    ,T44.LEVEL05_CODE PC_L5     
    ,T44.LEVEL05_NAME PC_L5_NAME
    ,T44.LEVEL06_CODE PC_L6      
    ,T44.LEVEL06_NAME PC_L6_NAME 
    ,T44.LEVEL07_CODE PC_L7      
    ,T44.LEVEL07_NAME PC_L7_NAME      
    ,T44.LEVEL08_CODE PC_L8        
    ,T44.LEVEL08_NAME PC_L8_NAME        
    ,T44.LEVEL09_CODE PC_L9      
    ,T44.LEVEL09_NAME PC_L9_NAME 
    ,T44.LEVEL10_CODE PC_L10     
    ,T44.LEVEL10_NAME PC_L10_NAME     
    ,PR.LEVEL01_CODE PR_L1        
    ,PR.LEVEL01_NAME PR_L1_NAME       
    ,PR.LEVEL02_CODE PR_L2          
    ,PR.LEVEL02_NAME PR_L2_NAME             
    ,PR.LEVEL03_CODE PR_L3          
    ,PR.LEVEL03_NAME PR_L3_NAME             
    ,PR.LEVEL04_CODE PR_L4          
    ,PR.LEVEL04_NAME PR_L4_NAME     
    ,PR.LEVEL05_CODE PR_L5          
    ,PR.LEVEL05_NAME PR_L5_NAME
    ,PR.LEVEL06_CODE PR_L6        
    ,PR.LEVEL06_NAME PR_L6_NAME       
    ,PR.LEVEL07_CODE PR_L7          
    ,PR.LEVEL07_NAME PR_L7_NAME             
    ,PR.LEVEL08_CODE PR_L8          
    ,PR.LEVEL08_NAME PR_L8_NAME             
    ,PR.LEVEL09_CODE PR_L9          
    ,PR.LEVEL09_NAME PR_L9_NAME     
    ,PR.LEVEL10_CODE PR_L10         
    ,PR.LEVEL10_NAME PR_L10_NAME	    

	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_AC
	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_KG, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_KG_AC
	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_L, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_L_AC
	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_KWH, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_KWH_AC
	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_SM3, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_SM3_AC
	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_SALES_LINE_AMT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_SALES_LINE_AMT_AC
	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_MARGIN_LINE_AMT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_MARGIN_LINE_AMT_AC
	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_SALES_LINE_AMT*ER.EXCHANGE_RATE_FLOAT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_SALES_LINE_AMT_EUR_AC
	,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_MARGIN_LINE_AMT*ER.EXCHANGE_RATE_FLOAT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_MARGIN_LINE_AMT_EUR_AC
		
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_PY
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_KG, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_KG_PY
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_L, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_L_PY
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_KWH, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_KWH_PY
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_SM3, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_SM3_PY
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_SALES_LINE_AMT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_SALES_LINE_AMT_PY
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_MARGIN_LINE_AMT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_MARGIN_LINE_AMT_PY
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_SALES_LINE_AMT*ER.EXCHANGE_RATE_FLOAT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_SALES_LINE_AMT_EUR_PY
	,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_MARGIN_LINE_AMT*ER.EXCHANGE_RATE_FLOAT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_MARGIN_LINE_AMT_EUR_PY       	
	,0 AS SALES_LINE_QTY_BU
	,0 AS SALES_LINE_QTY_KG_BU
	,0 AS SALES_LINE_QTY_L_BU
	,0 AS SALES_LINE_QTY_KWH_BU
	,0 AS SALES_LINE_QTY_SM3_BU
	,0 AS NET_SALES_LINE_AMT_BU  
	,0 AS MARGIN_LINE_AMT_BU
	,0 AS NET_SALES_LINE_AMT_EUR_BU
	,0 AS NET_MARGIN_LINE_AMT_EUR_BU
	,1 AS PPN_SRC
FROM 
	APLSDB.F_SALES_ALL_DAILY T
	left JOIN 
	APLSDB.D_DATE DAT 
		ON DAT.DATE_SID=T.ACCOUNTING_DATE_SID AND DAT.DATE <> 'N/A'	
----------------COMPANY----------------------------------------------------
INNER JOIN 
	APLSDB.D_COMPANY CO 
		ON CO.COMPANY_SID=T.COMPANY_SID  --AND CO.VLD_TO_DT='9999-12-31 00:00:00'
-----------------PROFITNI CENTRI---------------------------------------------
--INNER JOIN  V_PROFIT_CENTER_BI T44               ON  T.SALES_POINT_SID  = T44.PROFIT_CENTER_SID     AND T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' 
INNER JOIN  
	APLSDB.F_PROFIT_CENTER_BI T44               
		ON T.SALES_POINT_SID  = T44.PROFIT_CENTER_SID     
		AND T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' 
 --------------PRODUKTI----------------------------------------------------------
INNER JOIN       
	APLSDB.V_PRODUCT_BI PR
		ON T.PRODUCT_SID = PR.PRODUCT_SID
		AND PR.HIERARCHY_EXT_REFR = 'PR|SAP' --AND PROD.PRODUCT_CODE LIKE '%GR%'-- -- 'PR|PIS'                         
----------------------STRANKA---------------------------------------------------
LEFT JOIN 
	APLSDB.D_CUSTOMER CU                 
		ON CU.CUSTOMER_SID = T.CUSTOMER_SID
LEFT JOIN 
	APLSDB.D_CUSTOMER_DATASET CD
		ON CD.CUSTOMER_DATASET_SID=CU.DATASET_CUSTOMER_TYPE_SID 
		AND CD.VLD_TO_DT='9999-12-31 00:00:00'
--------------------PLA?EVANJE----------------------------------------------------------------------
INNER JOIN 
	APLSDB.D_EXCHANGE_RATE ER 
		ON T.CURRENCY_SID = ER.CURRENCY_FROM_SID 
		AND ER.CURRENCY_TO_EXT_REFR ='EUR' 
		AND ER.EXCHANGE_RATE_TYPE_EXT_REFR = 'D' 
       	AND CAST(TO_VARCHAR(ER.EFF_TO_DT, 'YYYYMMDD')  AS INTEGER ) = T.ACCOUNTING_DATE_SID 
       	AND CO.COUNTRY_SID=ER.COUNTRY_SID --AND CO.COUNTRY_EXT_REFR=ER.COUNTRY_EXT_REFR
INNER JOIN 
	APLSDB.D_PAYMENT_METHOD_HIERARCHY PM 
		ON T.PAYMENT_METHOD_SID=PM.PAYMENT_METHOD_SID
----------------------------------------------------------------------------------

WHERE FLOOR(T.ACCOUNTING_DATE_SID / 10000) IN (YEAR(CURRENT_DATE), YEAR(CURRENT_DATE) - 1) 
	AND MONTH(CURRENT_DATE) = substr(T.accounting_date_sid, 5, 2)  --AND  MONTH(DATE(DAT.DATE)) = 3  -- 
	AND CO.COMPANY_CODE_PIS = '9110'
	AND T44.LEVEL05_CODE='0P111'
	AND PR.LEVEL01_CODE <> '06'

--- testing
and T.ACCOUNTING_DATE_SID = 20200201
and  PROFIT_CENTER_EXT_REFR = '2707|PIS'
 	
GROUP BY
        CO.COMPANY_CODE_PIS
        ,CO.COMPANY_CODE
        ,CO.NAME 
--        ,T.ACCOUNTING_DATE_SID 
        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN T.ACCOUNTING_DATE_SID  ELSE T.ACCOUNTING_DATE_SID + 10000 END          
        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN dat.ext_refr  ELSE dateadd(month, 12, to_date(dat.date)) END            
--        ,TO_DATE(TO_CHAR(DAT.MONTH_ID*100+1)) 
--        ,DATX.DATE            
        ,T44.PROFIT_CENTER_EXT_REFR 
        ,T44.PROFIT_CENTER_NAME
        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 1 ELSE 2 END) 
        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 'B2C' ELSE 'B2B' END) 
        ,T.IS_OWN_USAGE
	, CASE WHEN PM.PAYMENT_METHOD_SID = -1 THEN 'N/A'
	        WHEN PM.LEVEL02_CODE = 'GOTOVINA'                          THEN 'Gotovina'                   
	        WHEN PM.LEVEL04_CODE = 'BAN?NE KARTICE'                    THEN 'Ban?ne kartice'             
---- novo 3.4.--------------------------                
                when pm.LEVEL04_CODE in ('M - PETROL PLA�ILNE KARTICE', 'M - Petrol pla�ilne kartice')       then 'Petrol pla�ilne kartice'                            
--                when pm.LEVEL04_CODE = 'M - PETROL PLAČILNE KARTICE'       then 'Petrol pla�?ilne kartice'
---- novo 3.4.--------------------------                

	        WHEN PM.LEVEL04_CODE = 'PETROLOVE POSLOVNE KARTICE'        THEN 'Petrolove poslovne kartice' 
	        WHEN PM.LEVEL04_CODE = 'TUJE KAMIONSKE KARTICE'            THEN 'Tuje kamionske kartice'     
	        ELSE 'Other' END 
        ,PR.PRODUCT_CODE 
        ,PR.PRODUCT_NAME_SHORT       
        ,T44.LEVEL01_EXT_REFR         
        ,T44.LEVEL02_EXT_REFR       
        ,T44.LEVEL03_EXT_REFR         
        , T44.LEVEL04_EXT_REFR 
        ,T44.LEVEL05_EXT_REFR         
        ,T44.LEVEL06_EXT_REFR       
        ,T44.LEVEL07_EXT_REFR          
        ,T44.LEVEL08_EXT_REFR 
        ,T44.LEVEL09_EXT_REFR         
        ,T44.LEVEL10_EXT_REFR 
        ,T44.LEVEL01_CODE       
        ,T44.LEVEL01_NAME  
        ,T44.LEVEL02_CODE       
        , T44.LEVEL02_NAME       
        ,T44.LEVEL03_CODE         
        ,T44.LEVEL03_NAME         
        ,T44.LEVEL04_CODE       
        ,T44.LEVEL04_NAME  
        ,T44.LEVEL05_CODE      
        ,T44.LEVEL05_NAME 
        ,T44.LEVEL06_CODE       
        ,T44.LEVEL06_NAME  
        ,T44.LEVEL07_CODE       
        , T44.LEVEL07_NAME       
        ,T44.LEVEL08_CODE         
        ,T44.LEVEL08_NAME         
        ,T44.LEVEL09_CODE       
        ,T44.LEVEL09_NAME  
        ,T44.LEVEL10_CODE      
        ,T44.LEVEL10_NAME           
        ,PR_L1
        ,PR_L1_NAME
        ,PR_L2
        ,PR_L2_NAME
        ,PR_L3
        ,PR_L3_NAME
        ,PR_L4
        ,PR_L4_NAME
        ,PR_L5
        ,PR_L5_NAME
        ,PR_L6
        ,PR_L6_NAME
        ,PR_L7
        ,PR_L7_NAME
        ,PR_L8
        ,PR_L8_NAME
        ,PR_L9
        ,PR_L9_NAME
        ,PR_L10
        ,PR_L10_NAME             
		