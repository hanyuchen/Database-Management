SELECT a.page_search_term, a.views, a.dd_ctr, a.dd_1_ctr, a.dd_2_ctr, a.dd_3_ctr, a.dd_4_ctr, a.dd_5_ctr

From
(SELECT
 page_search_term,
 sum(case when event_trigger='view' then 1 else 0 end) as views,
 sum(case when (event_trigger='click' and click_info['it'] = 'prod_NDS') then 1 else 0 end) as dd_clicks,
 sum(case when (event_trigger='click' and click_info['it'] = 'prod_NDS') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as dd_ctr,
 sum(case when (event_trigger='click' and click_info['it'] = 'prod_NDS' and click_info['t5pos'] = '1') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as dd_1_ctr,
 sum(case when (event_trigger='click' and click_info['it'] = 'prod_NDS' and click_info['t5pos'] = '2') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as dd_2_ctr,
 sum(case when (event_trigger='click' and click_info['it'] = 'prod_NDS' and click_info['t5pos'] = '3') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as dd_3_ctr,
 sum(case when (event_trigger='click' and click_info['it'] = 'prod_NDS' and click_info['t5pos'] = '4') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as dd_4_ctr,
 sum(case when (event_trigger='click' and click_info['it'] = 'prod_NDS' and click_info['t5pos'] = '5') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as dd_5_ctr

FROM
venus_db.data

WHERE
 dt between '20161107' and '20161120'
 AND (event_trigger='view' or event_trigger='click')
 AND page_info['ddb'] like ('%prod_NDS%') 
 AND market='tw'
 AND vertical='websearch'
 AND platform='pc'
 GROUP BY page_search_term
) a

where 

a.dd_ctr > 0.12
AND (a.dd_1_ctr < a.dd_2_ctr or a.dd_1_ctr < a.dd_3_ctr or a.dd_1_ctr < a.dd_4_ctr or a.dd_1_ctr < a.dd_5_ctr)
ORDER BY a.views desc
limit 500;
