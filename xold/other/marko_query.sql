--  DWH_DEV , DWH_PROD
USE DATABASE DWH_prod;
USE SCHEMA APLSDB;
--
--select tip_kartice, PAYMENT_METHOD_NAME, sum(promet), count(distinct DOCUMENT_HDR_CODE)
--from
--(

--select sum(prihodek), substring(ACCOUNTING_DATE_SID,5,2) mesec, substring(ACCOUNTING_DATE_SID,0,4) leto
--from
--(
    

--CREATE VIEW SALES_ALL AS 
SELECT  
         t.DOKUMENT
        ,T.DOCUMENT_HDR_CODE,    T.DOCUMENT_LINE_CODE 
        ,T.CUSTOMER_SID 
        ,cU.CUSTOMER_CODE_PIS Customer_pis_code
        ,co.COMPANY_CODE_PIS
        ,t44.PROFIT_CENTER_EXT_REFR STM_PIS
        ,t44.PROFIT_CENTER_NAME pc_name
        ,T.SALES_POINT_SID
        ,T.ACCOUNTING_DATE_SID
        ,dat.ext_refr datum
        ,T.TRANSACTION_TIME_SID 
        ,T.PAYMENT_METHOD_SID, pm.PAYMENT_METHOD_NAME
        ,T.PAYMENT_SYSTEM_SID, ps.PAYMENT_SYSTEM_code, ps.PAYMENT_SYSTEM_NAME         
        ,T.CURRENCY_SID
        ,T.PAYMENT_CARD_SID,     T.LOYALTY_CARD_SID
        ,T.IS_OWN_USAGE,         T.TRANSACTION_STATUS_SID 
        ,T.IS_MASTER_CONTRACT,   T.IS_PURCHASE_AGREEMENT        
        ,T.PRODUCT_SID
        ,prod.PRODUCT_CODE_PIS artikel
        ,prod.PRODUCT_NAME_SHORT naziv_artikla
        ,SALES_LINE_QTY kolicina
        ,INVOICE_LINE_AMT promet --FR
        ,NET_SALES_LINE_AMT prihodek
        ,NET_MARGIN_LINE_AMT cista_marza
        ,PURCHASE_LINE_AMT nabavna_vrednost_prodaje
        ,PURCHASE_LINE_PRICE nabavna_cena
        
              
        ,MARGIN_DISCOUNT_LINE_AMT        

         --  dodaj vse atribute
         
        ,REWARD_SPENT_LINE_SID porabljena_nagrada_sid
       , lt.EXT_REFR sifra
        ,lt.description opis_nagrade_porabljena
        ,REWARD_SPENT_LINE_AMT kolicina_nagrade
      ,REWARD_ACQ_1_HDR_SID, lt1.description opis_nagrade_lt1,  REWARD_ACQ_2_HDR_SID , lt2.description opis_nagrade_lt2, REWARD_ACQ_3_HDR_SID, lt3.description opis_nagrade_lt3, REWARD_ACQ_4_HDR_SID, lt4.description opis_nagrade_lt4, REWARD_ACQ_5_HDR_SID, REWARD_ACQ_6_HDR_SID, REWARD_ACQ_7_HDR_SID, REWARD_ACQ_8_HDR_SID, REWARD_ACQ_9_HDR_SID, REWARD_ACQ_10_HDR_SID
        ,REWARD_ACQ_1_HDR_AMT,  REWARD_ACQ_2_HDR_AMT, REWARD_ACQ_3_HDR_AMT, REWARD_ACQ_4_HDR_AMT, REWARD_ACQ_5_HDR_AMT, REWARD_ACQ_6_HDR_AMT, REWARD_ACQ_7_HDR_AMT, REWARD_ACQ_8_HDR_AMT, REWARD_ACQ_9_HDR_AMT, REWARD_ACQ_10_HDR_AMT
        , ca.CARD_TYPE_EXT_REFR tip_kartice
        , ca.CARD_STATUS_EXT_REFR status_kartice
        , ca.EXT_REFR pis_STK
        , ca.ELECTROMOBILITY_CARD elektromobilnost
        , ca.VIRTUAL_CARD virtualna
        , t44.LEVEL01_EXT_REFR, t44.LEVEL02_EXT_REFR, t44.LEVEL03_EXT_REFR, t44.LEVEL04_EXT_REFR, t44.LEVEL05_EXT_REFR, t44.LEVEL06_EXT_REFR, t44.LEVEL07_EXT_REFR, t44.LEVEL08_EXT_REFR, t44.LEVEL09_EXT_REFR, t44.LEVEL10_EXT_REFR
        , L1.product_code  , L2.product_code  L2 , L3.product_code  L3, L4.product_code  L4, L5.product_code  L5, L6.product_code  L6, L7.product_code  L7, L8.product_code  L8

       -- ,prod.LEVEL02_NAME L2, prod.LEVEL03_NAME L3, prod.LEVEL04_NAME L4, prod.LEVEL05_NAME L5, prod.LEVEL06_NAME L6, prod.LEVEL07_NAME L7, prod.LEVEL08_NAME L8, prod.LEVEL09_NAME L9, prod.LEVEL10_NAME L10

        
FROM V_SALES_ALL T

inner join D_Date dat on dat.DATE_SID=t.ACCOUNTING_DATE_SID
----------------COMPANY----------------------------------------------------
inner join D_company co on co.company_sid=T.COMPANY_SID  --and co.VLD_TO_DT='9999-12-31 00:00:00'

-----------------PROFITNI CENTRI---------------------------------------------
--INNER JOIN  D_PROFIT_CENTER T4                 ON  T4.EXT_REFR               = '9110' --'8957' -- 131 --'102' -- '572' --'8940'  --'102' --'' -- 8940'    --'2311'
--                                                                                                   and t4.profit_center_SID in(t44.LEVEL01_SID, t44.LEVEL02_SID, t44.LEVEL03_SID, t44.LEVEL04_SID, t44.LEVEL05_SID, t44.LEVEL06_SID, t44.LEVEL07_SID, t44.LEVEL08_SID, t44.LEVEL09_SID, t44.LEVEL10_SID)
INNER JOIN  V_PROFIT_CENTER_BI T44               ON  T.SALES_POINT_SID  = T44.PROFIT_CENTER_SID     and t44.HIERARCHY_EXT_REFR =  'PC|PIS' -- 'PR|PIS'    -- AND T.ACCOUNTING_DATE_SID BETWEEN (TO_NUMBER(TO_CHAR(T444.VLD_FM_DT,'YYYYMMDD'))) 
--
--LEFT OUTER JOIN D_PROFIT_CENTER_HIERARCHY T44  ON  T444.PROFIT_CENTER_SID = T44.PROFIT_CENTER_SID                                                
--LEFT OUTER JOIN D_PROFIT_CENTER T444_L8        ON  T444_L8.EXT_REFR = T44.LEVEL08_EXT_REFR   and  T444_L8.VLD_TO_DT='9999-12-31 00:00:00'
--LEFT OUTER JOIN D_PROFIT_CENTER T444_L7        ON  T444_L7.EXT_REFR = T44.LEVEL07_EXT_REFR   and  T444_L7.VLD_TO_DT='9999-12-31 00:00:00'
--LEFT OUTER JOIN D_PROFIT_CENTER T444_L6        ON  T444_L6.EXT_REFR = T44.LEVEL06_EXT_REFR   and  T444_L6.VLD_TO_DT='9999-12-31 00:00:00'
--LEFT OUTER JOIN D_PROFIT_CENTER T444_L5        ON  T444_L5.EXT_REFR = T44.LEVEL05_EXT_REFR   and  T444_L5.VLD_TO_DT='9999-12-31 00:00:00'
--LEFT OUTER JOIN D_PROFIT_CENTER T444_L4        ON  T444_L4.EXT_REFR = T44.LEVEL04_EXT_REFR   and  T444_L4.VLD_TO_DT='9999-12-31 00:00:00'
--LEFT OUTER JOIN D_PROFIT_CENTER T444_L3        ON  T444_L3.EXT_REFR = T44.LEVEL03_EXT_REFR   and  T444_L3.VLD_TO_DT='9999-12-31 00:00:00'
--LEFT OUTER JOIN D_PROFIT_CENTER T444_L2        ON  T444_L2.EXT_REFR = T44.LEVEL02_EXT_REFR   and  T444_L2.VLD_TO_DT='9999-12-31 00:00:00'
--LEFT OUTER JOIN D_PROFIT_CENTER T444_L1        ON  T444_L1.EXT_REFR = T44.LEVEL01_EXT_REFR   and  T444_L1.VLD_TO_DT='9999-12-31 00:00:00'  

--/*--------------PRODUKTI----------------------------------------------------------
--inner join D_PRODUCT t8                         on T8.EXT_REFR = '100|GR'  AND T.ACCOUNTING_DATE_SID BETWEEN (TO_NUMBER(TO_CHAR(t8.VLD_FM_DT,'YYYYMMDD'))) AND (TO_NUMBER(TO_CHAR(t8.VLD_TO_DT,'YYYYMMDD'))) and t8.VLD_TO_DT='9999-12-31 00:00:00' --product--'4914|GR'   --'62|BL'  --'4914|GR'  --'18|BL'    
--inner join D_PRODUCT_hierarchy t88              on t88.PRODUCT_SID = t.PRODUCT_SID
--                                                  and t8.PRODUCT_SID in (t88.LEVEL01_SID,t88.LEVEL02_SID,t88.LEVEL03_SID,t88.LEVEL04_SID,t88.LEVEL05_SID,t88.LEVEL06_SID,t88.LEVEL07_SID,t88.LEVEL08_SID,t88.LEVEL09_SID,t88.LEVEL10_SID)*/
 --------------PRODUKTI----------------------------------------------------------
--INNER JOIN       V_PRODUCT_BI PROD                ON  T.PRODUCT_SID     =PROD.PRODUCT_SID  --                            AND T.ACCOUNTING_DATE_SID BETWEEN (TO_NUMBER(TO_CHAR(PROD.VLD_FM_DT,'YYYYMMDD'))) AND (TO_NUMBER(TO_CHAR(PROD.VLD_TO_DT,'YYYYMMDD')))

 --------------PRODUKTI----------------------------------------------------------
INNER JOIN       D_PRODUCT PROD                ON  T.PRODUCT_SID     =PROD.PRODUCT_SID                                                                               --    AND T.ACCOUNTING_DATE_SID BETWEEN (TO_NUMBER(TO_CHAR(PROD.VLD_FM_DT,'YYYYMMDD'))) AND (TO_NUMBER(TO_CHAR(PROD.VLD_TO_DT,'YYYYMMDD')))
INNER JOIN       D_PRODUCT_HIERARCHY PRODH     ON  PRODH.PRODUCT_SID =PROD.PRODUCT_SID       and prodh.HIERARCHY_EXT_REFR = 'PR|PIS' -- 'PR|PIS'                                                   --  AND  PRODH.VLD_TO_DT='9999-12-31 00:00:00'                                 
INNER JOIN       D_PRODUCT L1                  ON  PRODH.LEVEL01_code =L1.product_code            
INNER JOIN       D_PRODUCT L2                  ON  PRODH.LEVEL02_code =L2.product_code 
INNER JOIN       D_PRODUCT L3                  ON  PRODH.LEVEL03_code =L3.product_code 
INNER JOIN       D_PRODUCT L4                  ON  PRODH.LEVEL04_code =L4.product_code 
INNER JOIN       D_PRODUCT L5                  ON  PRODH.LEVEL05_code =L5.product_code 
INNER JOIN       D_PRODUCT L6                  ON  PRODH.LEVEL06_code =L6.product_code 
INNER JOIN       D_PRODUCT L7                  ON  PRODH.LEVEL07_code =L7.product_code 
INNER JOIN       D_PRODUCT L8                  ON  PRODH.LEVEL08_code =L8.product_code                                                    
                                                   
----------------------STRANKA---------------------------------------------------
inner JOIN D_CUSTOMER CU                 ON CU.CUSTOMER_SID = T.CUSTOMER_SID -- AND T.ACCOUNTING_DATE_SID BETWEEN (TO_NUMBER(TO_CHAR(CU.VLD_FM_DT,'YYYYMMDD'))) AND (TO_NUMBER(TO_CHAR(CU.VLD_TO_DT,'YYYYMMDD')))--CUSTOMER
--LEFT OUTER JOIN D_CUSTOMER_H_OE  CUH          ON CU.EXT_REFR = CUH.EXT_REFR
--inner join d_customer_psn cp on cu.customer_psn_sid=cp.customer_psn_sid     and cp.VLD_TO_DT='9999-12-31 00:00:00' --customer psn
--left outer join d_customer_core cc on cu.customer_core_sid=cc.customer_core_sid  and cc.VLD_TO_DT='9999-12-31 00:00:00' --customer core
--inner join d_customer_payment CP on cu.customer_payment_sid = CP.customer_payment_sid and  cp.VLD_TO_DT='9999-12-31 00:00:00'
 INNER JOIN D_CUSTOMER_DATASET TYPE ON TYPE.CUSTOMER_DATASET_SID=cu.DATASET_CUSTOMER_TYPE_SID AND TYPE.VLD_TO_DT='9999-12-31 00:00:00'
---------------------KARTICA----------------------------------------------------
--left outer join d_customer_card cca on t.loyalty_card_sid=cca.customer_card_sid    and cca.VLD_TO_DT='9999-12-31 00:00:00' --najprej customer card
left outer join d_card ca on t.loyalty_card_sid=ca.card_sid                --           and ca.VLD_TO_DT='9999-12-31 00:00:00'-- and ca.VLD_FM_dt >= '2018-11-01' --veljavne kartice --card-- nato card na customer card
--inner join d_card_status cs on ca.card_status_sid=cs.card_status_sid       and cs.VLD_TO_DT='9999-12-31 00:00:00' --card status
--left outer join d_card ca on t.payment_card_sid=ca.card_sid                and ca.VLD_TO_DT='9999-12-31 00:00:00' --poslovne kartice 
----------------------NAGRADE---------------------------------------------------------------------
inner join d_loyalty_type lt on t.reward_spent_line_sid=lt.loyalty_type_sid --porabljene nagrade

INNER JOIN       d_loyalty_type lt1            ON  t.REWARD_ACQ_1_HDR_SID =lt1.loyalty_type_sid  
INNER JOIN       d_loyalty_type lt2            ON  t.REWARD_ACQ_2_HDR_SID =lt2.loyalty_type_sid 
INNER JOIN       d_loyalty_type lt3            ON  t.REWARD_ACQ_3_HDR_SID =lt3.loyalty_type_sid 
INNER JOIN       d_loyalty_type lt4            ON  t.REWARD_ACQ_4_HDR_SID =lt4.loyalty_type_sid         

---inner join d_loyalty lo on lt.loyalty_sid=lo.loyalty_sid --nadgradnja, dodati ≈°e ime elementa nagrade, itd...
--------------------PLAƒåEVANJE----------------------------------------------------------------------
inner join d_payment_system ps on t.payment_system_sid=ps.payment_system_sid
inner join d_payment_method pm on t.payment_method_sid=pm.payment_method_sid
----------------------------------------------------------------------------------

where  t.ACCOUNTING_DATE_SID between 20190101  and 20190131 --ƒçasovno obdobje
and cU.CUSTOMER_CODE_PIS in ('3885718')--,'3885718','4407935','4170349')--pis öifra potroöniik
--and cU.CUSTOMER_CODE_PIS in ('4403983','4170360','3248268','3885718','4407935','4170349','3822005','4187189', '4069633','4062317')
--and cp.PETROL_EMPLOYEE_IND <> 0
--and t44.LEVEL05_EXT_REFR='8809|PIS'
and STM_PIS<>'13701|PIS'
AND   co.COMPANY_CODE_PIS = '9110'
--AND T.SALES_POINT_SID <> '27563'
AND   T.IS_OWN_USAGE = 0   ---- 0,1   
AND   TYPE.CUSTOMER_DATASET_CODE = 'F'
