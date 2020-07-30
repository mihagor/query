SELECT co.COMPANY_SID, co.COMPANY_CODE, ur.USERNAME,  ur.AREA, ur.SUB_AREA
FROM aplsdb.d_company co
inner join aplsdb.MDM_USER_RIGHTS ur on co.COMPANY_CODE = ur.COMPANY
where AREA = 'PR'  AND SUB_AREA = 'MP'
AND USERNAME = #sq($account.personalInfo.userName)#