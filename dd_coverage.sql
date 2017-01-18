SELECT clicks.page_search_term as query, total.views as totalviews, clicks.views/total.views as cov1, clicks.ctr as ctr, clicks.views as pv

FROM


(SELECT
 sum(case when event_trigger='view' then 1 else 0 end) as views
 
 FROM
 venus_db.data
 
 WHERE
 dt = '20161001'
 AND (event_trigger='view' or event_trigger='click')
 AND platform = 'pc'
 AND market = 'tw'
 AND vertical = 'websearch' ) total JOIN
 
 (SELECT
 page_search_term,
 sum(case when event_trigger='view' then 1 else 0 end) as views,
 sum(case when (event_trigger='click' and click_info['it'] = 'sys_kgactor_ykc') then 1 else 0 end)/sum(case when event_trigger='view' then 1 else 0 end) as ctr,
 sum(case when (event_trigger='click' and click_info['it'] = 'sys_kgactor_ykc') then 1 else 0 end) as clicks
 
 FROM
 venus_db.data
 
 WHERE
 dt = '20161001'
 AND (event_trigger='view' or event_trigger='click')
 AND page_info['ddb'] like '%sys_kgactor_ykc%'
 AND platform = 'pc'
 AND market = 'tw'
 AND vertical = 'websearch'
 group by page_search_term
 order by clicks desc
) clicks


WHERE
ctr < 1
order by pv desc
limit 200;
