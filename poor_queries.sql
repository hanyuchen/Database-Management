
set mapreduce.map.memory.mb=4096;

SELECT
 page_search_term,
 (case when sum(case when (event_trigger='view' and qtypeagg=1) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)<0.005 and sum(case when (event_trigger='click' and click_info['sec'] = 'rel') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)=0 and sum(case when (event_trigger='click' and click_info['sec'] = 'rel-bot') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)=0 and sum(case when (event_trigger='click' and click_info['sec'] = 'qss-qrw') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)=0 then 'Spam like'
       when sum(case when (event_trigger='view' and qtypeagg=0) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)>0.9 then 'Abandonment'
       when sum(case when (event_trigger='view' and qtypeagg=3) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)>0.35 then 'Reformulation'
       when (sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '1') then 1 else 0 end)=0)
             AND (sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '2') then 1 else 0 end)=0) then 'Poor top algo'
       else 'Others'
  end
 ) as type,
 count(distinct bcookie) as bcookies,
 sum(case when event_trigger='view' then 1 else 0 end) as views,
 sum(case when event_trigger='view' then 1 else 0 end)/count(distinct bcookie) as spbc,
 sum(case when (event_trigger='view' and qtypeagg=0) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as abandonment,
 sum(case when (event_trigger='view' and qtypeagg=1) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as result_click,
 sum(case when (event_trigger='view' and qtypeagg=3) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as reforumulation,
 sum(case when (event_trigger='click' and click_info['sec'] like ('ov%')) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as ads_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] like ('sc%')) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as dd_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'sr') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as algo_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '1') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as algo1_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '2') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as algo2_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '3') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as algo3_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '4') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as algo4_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '5') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as algo5_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'rel') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as nat_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'rel-bot') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as sat_ctr,
 sum(case when (event_trigger='click' and click_info['sec'] = 'qss-qrw') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as qrw_ctr
FROM
 venus_db.data
WHERE
  dt between '20160416' and '20160430'
  AND spaceid in ('2114705003','958806385','1351200416')
  AND (event_trigger='view' or event_trigger='click')
  AND page_info['pagenum']='1'
  AND page_info['ddinfo'] not like ('%sys_dictionary%')
  AND page_info['ddinfo'] not like ('%sys_fin_stock%')
group by page_search_term
having
  (sum(case when event_trigger='view' then 1 else 0 end)/count(distinct bcookie) between 1 and 9)
  AND (count(distinct bcookie)>10)
  AND
  (
    (sum(case when (event_trigger='view' and qtypeagg=0) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)>0.9
     AND sum(case when (event_trigger='view' and qtypeagg=1) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)<0.1
     AND sum(case when (event_trigger='click' and click_info['sec'] = 'rel') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)>0
     AND sum(case when (event_trigger='click' and click_info['sec'] = 'rel-bot') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)>0)
   OR
    (sum(case when (event_trigger='view' and qtypeagg=1) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)<0.1
     AND sum(case when (event_trigger='view' and qtypeagg=3) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) between 0.35 and 0.9
     AND sum(case when (event_trigger='click' and click_info['sec'] = 'sr') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)<0.2
     AND sum(case when (event_trigger='click' and click_info['sec'] = 'qss-qrw') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)<0.1)
   OR
    (
     sum(case when (event_trigger='view' and qtypeagg=1) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)>0.1
     AND sum(case when (event_trigger='click' and click_info['sec'] like ('sc%')) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)<0.2
     AND sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '1') then 1 else 0 end)=0
     AND sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '2') then 1 else 0 end)=0
     AND (
          sum(case when (event_trigger='click' and click_info['sec'] like ('sc%')) then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end)>0.1
          OR sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '3') then 1 else 0 end)>0.1
          OR sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '4') then 1 else 0 end)>0.1
          OR sum(case when (event_trigger='click' and click_info['sec'] = 'sr' and click_info['pos'] = '5') then 1 else 0 end)>0.1
         )  
    )
  )
order by views desc
limit 1000
;

