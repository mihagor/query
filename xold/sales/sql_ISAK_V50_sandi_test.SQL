---  COPA:    5.987.528
USE DATABASE DWH_dev;
USE SCHEMA APLsdb;

with pis as
(
SELECT   '1'
,ACCOUNTING_DATE_SID
,sum(nvl(A.PURCHASE_PRICE_AMAP_LINE_AMT,0)) amt, sum(nvl(a.SALES_LINE_QTY,0)) qty
,sum(nvl(A.PURCHASE_PRICE_AMAP_LINE_AMT,0)) / sum(nvl(a.SALES_LINE_QTY,0)) nvc
--,sum(A.PURCHASE_PRICE_AMAP_LINE_AMT) / float(sum(a.SALES_LINE_QTY))
--, sum(A.PURCHASE_PRICE_LINE_AMT), sum(STATE_FEE_LINE_AMT), sum(EXCISE_FEE_LINE_AMT), sum(MEMBERSHIP_FEE_LINE_AMT)
--,B.PRODUCT_CODE_PIS,  pc.profit_center_code, A.PURCHASE_PRICE_LINE_AMT, A.*
FROM     APLSDB.F_ISSUANCE A
INNER JOIN APLSDB.D_PRODUCT B                ON A.PRODUCT_SID=B.PRODUCT_SID                 AND B.VLD_TO_DT='9999-12-31' 
INNER JOIN APLSDB.D_COMPANY C                ON C.COMPANY_SID=A.COMPANY_SID                 AND C.VLD_TO_DT='9999-12-31' 
inner join APLSDB.D_profit_center pc            on pc.profit_center_sid = a.sales_point_sid       -- and pc.profit_center_code = '9599'  --'2311'
WHERE  1=1  --and PPN_SRC in(2, 3) 
        AND ACCOUNTING_DATE_SID between 20190301  and  20190331
        AND COUNTRY_EXT_REFR = 'SI'
and b.product_code = '18|BL'
--and  pc.profit_center_code  in ('9640|PIS','9599|PIS','9641|PIS','8935|PIS','9572|PIS')
--and  pc.profit_center_code  in ('9640','9599','9641','8935','9572')   ----  vsi del PC 100101
and nvl(a.PURCHASE_PRICE_AMAP_LINE_AMT,0) <> 0
group by ACCOUNTING_DATE_SID 
)

select sap.nvc_sap*pis.qty, pis.*, sap.*
from 
( 
SELECT '1'
--            A.PRCTR
--            ,A.ARTNR  
            ,CAST(A.BUDAT AS INTEGER) AS ACCOUNTING_DATE_SAP
                ,sum(a.vv001) kolicina
                ,sum(A.VV300)  nv_vrednost 
                ,sum(A.VV300) / sum(a.vv001) nvc_sap  
FROM   APLLOAD.ST_SAP_SAPABAP1_CE11000 A
LEFT JOIN            APLLOAD.ST_SAP_SAPABAP1_TVFK B                    ON A.FKART = B.FKART                                 AND A.MANDT = B.MANDT        
INNER JOIN        APLLOAD.ST_SAP_SAPABAP1_IPRODUCT PR                                                    ON PR.PRODUCT = A.ARTNR  --                            AND PR.PRODUCTTYPE = 'ZOIL'                                  AND PR.MANDT='400'
WHERE                
                A.PALEDGER = '01'
                AND A.MANDT= '400'
                AND (A.COPA_AWTYP ='VBRK' AND B.FKTYP = 'W') 
                AND A.BUKRS = '1000'
                AND A.PRCTR =  '0000100101'
                AND A.ARTNR = '000000000000000018'
                AND budat between  '20190301'   and '20190331'
group by    CAST(A.BUDAT AS INTEGER)             
) sap
full outer join pis pis        on pis.ACCOUNTING_DATE_SID = sap.ACCOUNTING_DATE_SAP
;

---1.3:  287569.115492	820564.000
---23.3    4555.538547	12999.000
--skupaj    292124.653   833563

-- qty  15,499,409
-- f_iss amt 5 961 518
--ce11   amt 5 987 528
---dif  25 010 eur

--- pis= sap qty 14 665 846
--- prazni denvi  qty 833 563
--- cena_avg = (5.987 528 - 5 669 782) / (15 499 409 - 14 665 846) 
--  cena_avg = 317 746 / 833 563
-- cena_avg  = 0,381190143    cena koju treba uzet za 1.3. in 24.3. 
--- v f_issuance jest 0,35045300


