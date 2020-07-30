use database dwh_prod;

WITH DAILY AS(
                SELECT          
                       CO.COUNTRY_EXT_REFR
                       ,CO.COMPANY_CODE_PIS
                       ,CASE WHEN CO.COMPANY_CODE = '821071' THEN '3000' ELSE CO.COMPANY_CODE END AS COMPANY_CODE
                       ,CASE WHEN CO.COMPANY_CODE = '821071' THEN 'Petrol d.o.o., Zagreb' ELSE CO.NAME END AS COMPANY_NAME
                       ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN T.ACCOUNTING_DATE_SID  ELSE T.ACCOUNTING_DATE_SID + 10000 END  ACCOUNTING_DATE_SID
                       ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN DAT.EXT_REFR  ELSE DATEADD(MONTH, 12, TO_DATE(DAT.DATE)) END  ACCOUNTING_DATE 
                       ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 1 ELSE 2 END) AS CUSTOMER_TYPE_CODE
                       ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 'B2C' ELSE 'B2B' END) AS CUSTOMER_TYPE
                       ,T.IS_OWN_USAGE
                       , CASE WHEN PM.PAYMENT_METHOD_SID = -1 THEN 'N/A'
                               WHEN UPPER(PM.LEVEL02_CODE) = 'GOTOVINA' THEN 'Gotovina'                   
                               WHEN UPPER(PM.LEVEL04_CODE) = 'BANÈNE KARTICE' THEN 'Banène kartice'             
                               WHEN UPPER(PM.LEVEL04_CODE) = 'M - PETROL PLAÈILNE KARTICE' THEN 'Petrol plaèilne kartice'
                               WHEN UPPER(PM.LEVEL04_CODE) = 'PETROLOVE POSLOVNE KARTICE' THEN 'Petrolove poslovne kartice' 
                               WHEN UPPER(PM.LEVEL04_CODE) = 'TUJE KAMIONSKE KARTICE' THEN 'Tuje kamionske kartice'     
                               ELSE 'Other' END AS PAYMENT_METHOD    
                    ,PR.PRODUCT_CODE 
                    ,PR.PRODUCT_NAME_SHORT
                    ,T44.LEVEL01_EXT_REFR PC_LEVEL01_EXT_REFR        
                    ,T44.LEVEL02_EXT_REFR PC_LEVEL02_EXT_REFR     
                    ,T44.LEVEL03_EXT_REFR PC_LEVEL03_EXT_REFR        
                    , T44.LEVEL04_EXT_REFR PC_LEVEL04_EXT_REFR
                               ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000', '812820') THEN T44.LEVEL05_EXT_REFR
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS' AND CO.COMPANY_CODE IN ('812892', '812968', '812969')  THEN 'N/A'
                          ELSE T44.LEVEL05_EXT_REFR END
                                               AS PC_LEVEL05_EXT_REFR                
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL06_EXT_REFR
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL06_EXT_REFR END               
                               AS PC_LEVEL06_EXT_REFR               
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL07_EXT_REFR
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS' AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL07_EXT_REFR END
                        AS PC_LEVEL07_EXT_REFR 
                    ,T44.LEVEL01_CODE PC_L1       
                    ,T44.LEVEL01_NAME PC_L1_NAME 
                    ,T44.LEVEL02_CODE PC_L2      
                    , T44.LEVEL02_NAME PC_L2_NAME      
                    ,T44.LEVEL03_CODE PC_L3        
                    ,T44.LEVEL03_NAME PC_L3_NAME        
                    ,T44.LEVEL04_CODE PC_L4      
                    ,T44.LEVEL04_NAME PC_L4_NAME    
                               ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000', '812820') THEN T44.LEVEL05_CODE
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL05_CODE END
                                   AS PC_L5               
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000', '812820') THEN T44.LEVEL05_NAME
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL05_NAME END
                        AS PC_L5_NAME                   
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL06_CODE
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS' AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL06_CODE END
                        AS PC_L6                
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL06_NAME
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL06_NAME END
                        AS PC_L6_NAME               
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL07_CODE
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL07_CODE END
                        AS PC_L7      
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL07_NAME
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS' AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL07_NAME END
                        AS PC_L7_NAME
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
                LEFT JOIN 
                               APLSDB.D_DATE DAT 
                                               ON DAT.DATE_SID=T.ACCOUNTING_DATE_SID AND DAT.DATE <> 'N/A' 
                ----------------COMPANY----------------------------------------------------
                INNER JOIN 
                               APLSDB.D_COMPANY CO 
                                               ON CO.COMPANY_SID=T.COMPANY_SID  
                -----------------PROFITNI CENTRI---------------------------------------------
                --INNER JOIN  V_PROFIT_CENTER_BI T44              
                INNER JOIN  
                               APLSDB.F_PROFIT_CENTER_BI T44               
                                               ON T.SALES_POINT_SID  = T44.PROFIT_CENTER_SID     
                                               AND T44.HIERARCHY_EXT_REFR IN ('PC|STD_SAP_PIS', 'PC|PIS') 
                 --------------PRODUKTI----------------------------------------------------------
                INNER JOIN       
                               APLSDB.V_PRODUCT_BI PR
                                               ON T.PRODUCT_SID = PR.PRODUCT_SID
                                               AND PR.HIERARCHY_EXT_REFR = 'PR|SAP'                       
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
                
                WHERE DAT.YEAR IN (YEAR(CURRENT_DATE), YEAR(CURRENT_DATE) - 1)  
                               AND MONTH(CURRENT_DATE) = MONTH(DATE(DAT.DATE))
                               AND CO.COMPANY_CODE in ('1000', '3000', '821071','812820', '812892', '812968', '812969')
                               AND ((T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' and T44.LEVEL05_CODE in ('0P111')) OR (T44.HIERARCHY_EXT_REFR = 'PC|PIS' and T44.LEVEL03_CODE in ('4803', '6801', '3203', '6901')))
                               AND PR.LEVEL01_CODE <> '06'
                               
                GROUP BY
                        CO.COUNTRY_EXT_REFR
                       ,CO.COMPANY_CODE_PIS
                       ,CO.COMPANY_CODE
                        ,CO.NAME 
                                               ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN T.ACCOUNTING_DATE_SID  ELSE T.ACCOUNTING_DATE_SID + 10000 END          
                        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN DAT.EXT_REFR  ELSE DATEADD(MONTH, 12, TO_DATE(DAT.DATE)) END            
                       -- ,T44.PROFIT_CENTER_EXT_REFR 
                       -- ,T44.PROFIT_CENTER_NAME
                        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 1 ELSE 2 END) 
                        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 'B2C' ELSE 'B2B' END) 
                        ,T.IS_OWN_USAGE
                        ,PAYMENT_METHOD
                        ,PR.PRODUCT_CODE 
                        ,PR.PRODUCT_NAME_SHORT       
                        ,T44.LEVEL01_EXT_REFR         
                        ,T44.LEVEL02_EXT_REFR       
                        ,T44.LEVEL03_EXT_REFR         
                        , T44.LEVEL04_EXT_REFR 
                        ,PC_L1     
                        ,PC_L1_NAME
                        ,PC_L2     
                        ,PC_L2_NAME       
                        ,PC_L3         
                        ,PC_L3_NAME         
                        ,PC_L4       
                        ,PC_L4_NAME  
                        ,PC_L5      
                        ,PC_L5_NAME 
                        ,PC_L6       
                        ,PC_L6_NAME  
                        ,PC_L7      
                        ,PC_L7_NAME  
                        ,PC_LEVEL05_EXT_REFR
                        ,PC_LEVEL06_EXT_REFR
                        ,PC_LEVEL07_EXT_REFR   
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
)
,ATTRIBUTES AS
(
                SELECT  
        T44.PROFIT_CENTER_EXT_REFR,
        T44.PROFIT_CENTER_CODE,
        T44.PROFIT_CENTER_NAME,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'BS GEOGRAFSKO'                                                        THEN PCA.ATTRIBUTE_VALUE_STRING ELSE NULL END) AS BS_GEOGRAFSKO,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'LOKACIJA BS'                    THEN PCA.ATTRIBUTE_VALUE_STRING ELSE NULL END) AS LOKACIJA_BS,        
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'BS PO REGIJAH'                  THEN PCA.ATTRIBUTE_VALUE_STRING 
                 WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'BS PO REGIJAH PETROL BEOGRAD'   THEN PCA.ATTRIBUTE_VALUE_STRING 
                 ELSE NULL END) 
            AS BS_PO_REGIJAH,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'INŠTRUKTORJI SLOVENIJA'         THEN PCA.ATTRIBUTE_VALUE_STRING
                 WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'INŠTRUKTORJI BIH'               THEN PCA.ATTRIBUTE_VALUE_STRING 
                 WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'INŠTRUKTORJI HRVAŠKA'           THEN PCA.ATTRIBUTE_VALUE_STRING 
                 ELSE NULL END)                                                                                           
            AS INSTRUKTORJI,             
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'PRODAJNA POVRŠINA'              THEN PCA.ATTRIBUTE_VALUE_NUMERIC ELSE -1  END) AS PRODAJNA_POVRSINA,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) IN ('FRESH', 'FRESH - MINI', 'DOPEKA') THEN PCA.ATTRIBUTE_NAME     ELSE NULL END) AS FRESH,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'AVTOPRALNICE NA BS'             THEN PCA.ATTRIBUTE_VALUE_STRING ELSE NULL END) AS AVTOPRALNICA
        
FROM    
                APLSDB.F_PROFIT_CENTER_BI T44
LEFT JOIN 
APLSDB.D_PROFIT_CENTER_ATTRIBUTE PCA 
                ON T44.PROFIT_CENTER_SID = PCA.PROFIT_CENTER_SID
WHERE   UPPER(ATTRIBUTE_NAME) IN ('BS GEOGRAFSKO', 'LOKACIJA BS', 'BS PO REGIJAH', 'BS PO REGIJAH PETROL BEOGRAD',
                           'INŠTRUKTORJI SLOVENIJA', 'INŠTRUKTORJI BIH', 'INŠTRUKTORJI HRVAŠKA', 
                           'PRODAJNA POVRŠINA', 'FRESH', 'FRESH - MINI', 'DOPEKA', 'AVTOPRALNICE NA BS')
AND PCA.VLD_TO_DT = TO_DATE('9999-12-31', 'YYYY-MM-DD')
GROUP BY
        T44.PROFIT_CENTER_EXT_REFR,
        T44.PROFIT_CENTER_CODE,
        T44.PROFIT_CENTER_NAME
)

-------------------------------------------------------------------------------------------------------------------------------------
, test as (
-------------------------------------------------------------------------------------------------------------------------------------


SELECT
     D.COUNTRY_EXT_REFR 
    ,D.COMPANY_CODE_PIS
    ,D.COMPANY_CODE
    ,D.COMPANY_NAME
    ,D.ACCOUNTING_DATE_SID
    ,D.ACCOUNTING_DATE
    ,D.CUSTOMER_TYPE_CODE
    ,D.CUSTOMER_TYPE
    ,D.PAYMENT_METHOD
    ,D.IS_OWN_USAGE
    ,CASE WHEN D.PC_L7 = 'N/A' AND D.PC_L6 = 'N/A' AND D.PC_L5 = 'N/A'    THEN D.PC_LEVEL04_EXT_REFR
          WHEN D.PC_L7 = 'N/A' AND D.PC_L6 = 'N/A'                        THEN D.PC_LEVEL05_EXT_REFR 
          WHEN D.PC_L7 = 'N/A'                                            THEN D.PC_LEVEL06_EXT_REFR 
          ELSE D.PC_LEVEL07_EXT_REFR
          END AS PROFIT_CENTER_EXT_REFR
    ,CASE WHEN D.PC_L7 = 'N/A' AND D.PC_L6 = 'N/A' AND D.PC_L5 = 'N/A'    THEN D.PC_L4
          WHEN D.PC_L7 = 'N/A' AND D.PC_L6 = 'N/A'                        THEN D.PC_L5 
          WHEN D.PC_L7 = 'N/A'                                            THEN D.PC_L6 
          ELSE D.PC_L7
          END AS PROFIT_CENTER_CODE
    ,CASE WHEN D.PC_L7 = 'N/A' AND D.PC_L6 = 'N/A' AND D.PC_L5 = 'N/A'    THEN D.PC_L4_NAME
          WHEN D.PC_L7 = 'N/A' AND D.PC_L6 = 'N/A'                        THEN D.PC_L5_NAME 
          WHEN D.PC_L7 = 'N/A'                                            THEN D.PC_L6_NAME 
          ELSE D.PC_L7_NAME
          END AS PROFIT_CENTER_NAME
    ,IFNULL(A.BS_GEOGRAFSKO, 'N/A')         AS BS_GEOGRAFSKO    
    ,IFNULL(A.LOKACIJA_BS, 'N/A')           AS LOKACIJA_BS
    ,IFNULL(A.BS_PO_REGIJAH, 'N/A')         AS BS_PO_REGIJAH
    ,IFNULL(A.INSTRUKTORJI, 'N/A')          AS INSTRUKTORJI
    ,IFNULL(A.PRODAJNA_POVRSINA, -1)        AS PRODAJNA_POVRSINA
    ,IFNULL(A.FRESH, 'N/A')                 AS FRESH
    ,IFNULL(A.AVTOPRALNICA, 'N/A')          AS AVTOPRALNICA    
    ,D.PC_LEVEL01_EXT_REFR, D.PC_L1, D.PC_L1_NAME     
    ,D.PC_LEVEL02_EXT_REFR, D.PC_L2, D.PC_L2_NAME           
    ,D.PC_LEVEL03_EXT_REFR, D.PC_L3, D.PC_L3_NAME            
    ,D.PC_LEVEL04_EXT_REFR, D.PC_L4, D.PC_L4_NAME 
    ,D.PC_LEVEL05_EXT_REFR, D.PC_L5, D.PC_L5_NAME     
    ,D.PC_LEVEL06_EXT_REFR, D.PC_L6, D.PC_L6_NAME     
    ,D.PC_LEVEL07_EXT_REFR, D.PC_L7, D.PC_L7_NAME      
    ,D.PRODUCT_CODE, D.PRODUCT_NAME_SHORT  
    ,0 AS IS_AGGREGATED
    ,D.PR_L1, D.PR_L1_NAME
    ,D.PR_L2, D.PR_L2_NAME
    ,D.PR_L3, D.PR_L3_NAME
    ,D.PR_L4, D.PR_L4_NAME
    ,D.PR_L5, D.PR_L5_NAME
    ,D.PR_L6, D.PR_L6_NAME
    ,D.PR_L7, D.PR_L7_NAME
    ,D.PR_L8, D.PR_L8_NAME
    ,D.PR_L9, D.PR_L9_NAME
    ,D.PR_L10, D.PR_L10_NAME 
    ,D.SALES_LINE_QTY_AC                           
    ,D.SALES_LINE_QTY_KG_AC                        
    ,D.SALES_LINE_QTY_L_AC                         
    ,D.SALES_LINE_QTY_KWH_AC                       
    ,D.SALES_LINE_QTY_SM3_AC                       
    ,D.NET_SALES_LINE_AMT_AC                       
    ,D.NET_MARGIN_LINE_AMT_AC                      
    ,D.NET_SALES_LINE_AMT_EUR_AC
    ,D.NET_MARGIN_LINE_AMT_EUR_AC                                                      
    ,D.SALES_LINE_QTY_PY                          
    ,D.SALES_LINE_QTY_KG_PY                       
    ,D.SALES_LINE_QTY_L_PY                        
    ,D.SALES_LINE_QTY_KWH_PY                      
    ,D.SALES_LINE_QTY_SM3_PY                      
    ,D.NET_SALES_LINE_AMT_PY                      
    ,D.NET_MARGIN_LINE_AMT_PY                     
    ,D.NET_SALES_LINE_AMT_EUR_PY
    ,D.NET_MARGIN_LINE_AMT_EUR_PY
    ,D.SALES_LINE_QTY_BU         
    ,D.SALES_LINE_QTY_KG_BU      
    ,D.SALES_LINE_QTY_L_BU       
    ,D.SALES_LINE_QTY_KWH_BU     
    ,D.SALES_LINE_QTY_SM3_BU     
    ,D.NET_SALES_LINE_AMT_BU     
    ,D.MARGIN_LINE_AMT_BU        
    ,D.NET_SALES_LINE_AMT_EUR_BU 
    ,D.NET_MARGIN_LINE_AMT_EUR_BU
    ,D.PPN_SRC 
FROM    
                DAILY D
LEFT JOIN 
                ATTRIBUTES A  
                               ON A.PROFIT_CENTER_EXT_REFR = (CASE WHEN D.PC_L7 = 'N/A' AND D.PC_L6 = 'N/A' AND D.PC_L5 = 'N/A' THEN D.PC_LEVEL04_EXT_REFR
                                                       WHEN D.PC_L7 = 'N/A' AND D.PC_L6 = 'N/A' THEN D.PC_LEVEL05_EXT_REFR 
                                                       WHEN D.PC_L7 = 'N/A' THEN D.PC_LEVEL06_EXT_REFR 
                                                       ELSE D.PC_LEVEL07_EXT_REFR
                                                       END)                       
                                                       
----------------------------------------------------------------------------------------------                                                       
)

select
        sum(SALES_LINE_QTY_AC           ),                
        sum(SALES_LINE_QTY_KG_AC        ),                
        sum(SALES_LINE_QTY_L_AC         ),                
        sum(SALES_LINE_QTY_KWH_AC       ),                
        sum(SALES_LINE_QTY_SM3_AC       ),                
        sum(NET_SALES_LINE_AMT_AC       ),                
        sum(NET_MARGIN_LINE_AMT_AC      ),                
        sum(NET_SALES_LINE_AMT_EUR_AC   ),
        sum(NET_MARGIN_LINE_AMT_EUR_AC  ),                                                    
        sum(SALES_LINE_QTY_PY           ),               
        sum(SALES_LINE_QTY_KG_PY        ),               
        sum(SALES_LINE_QTY_L_PY         ),               
        sum(SALES_LINE_QTY_KWH_PY       ),               
        sum(SALES_LINE_QTY_SM3_PY       ),               
        sum(NET_SALES_LINE_AMT_PY       ),               
        sum(NET_MARGIN_LINE_AMT_PY      ),               
        sum(NET_SALES_LINE_AMT_EUR_PY   ),
        sum(NET_MARGIN_LINE_AMT_EUR_PY  ),
        sum(SALES_LINE_QTY_BU           ),
        sum(SALES_LINE_QTY_KG_BU        ),
        sum(SALES_LINE_QTY_L_BU         ),
        sum(SALES_LINE_QTY_KWH_BU       ),
        sum(SALES_LINE_QTY_SM3_BU       ),
        sum(NET_SALES_LINE_AMT_BU       ),
        sum(MARGIN_LINE_AMT_BU          ),
        sum(NET_SALES_LINE_AMT_EUR_BU   ),
        sum(NET_MARGIN_LINE_AMT_EUR_BU  )
        from test
