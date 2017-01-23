//Daily PV / Bcookies (UUs)

set mapreduce.map.memory.mb=4096;


-- pv and bcookies from 11/01 to 11/21 in TW Mobile SRP --
SELECT
  dt,
  page_info['thm'] as themeid,
  count(distinct bcookie) as bcookies,
  sum(case when is_page_view=true then 1 else 0 end) as views
 FROM
  venus_db.data
 WHERE
   dt between '20161101' and '20161101'
   AND spaceid='958806385'
   AND (event_trigger='view' or event_trigger='click')
   AND (page_info['thm_q'] = '0' and page_info['thm_u'] = '1')
  group by page_info['thm'], dt
  order by bcookies desc
;


//Daily Coverage
set mapreduce.map.memory.mb=4096;


-- all pvs from 11/01 to 11/21 in TW Mobile SRP --
SELECT
  dt,
  count(*) as pv
FROM
  venus_db.data
WHERE
   dt between '20161101' and '20161121'
   AND spaceid='958806385'
   AND is_page_view=true
  group by dt
;


-- all theme pvs from 11/01 to 11/21 in TW Mobile SRP --
SELECT
  dt,
  sum(case when event_trigger='view' then 1 else 0 end) as views
 FROM
  venus_db.data
 WHERE
   dt between '20161101' and '20161121'
   AND spaceid='958806385'
   AND is_page_view=true
   AND (event_trigger='view' or event_trigger='click')
   AND (page_info['thm_q'] = '1' or page_info['thm_u'] = '1')
  group by dt
;




-- pvs of each theme from 11/01 to 11/21 in TW Mobile SRP --


SELECT
  dt,
  page_info['thm'] as themeid,
  sum(case when event_trigger='view' then 1 else 0 end) as views
 FROM
  venus_db.data
 WHERE
   dt between '20161101' and '20161121'
   AND spaceid='958806385'
   AND is_page_view=true
   AND (event_trigger='view' or event_trigger='click')
   AND (page_info['thm_q'] = '1' or page_info['thm_u'] = '1')
  group by page_info['thm'], dt
;



//Click counts (per theme)
yes / no / banner / Line / Facebook clicks




set mapreduce.map.memory.mb=4096;


SELECT
  dt,
  page_info['thm'] as themeid,
  count(distinct bcookie) as bcookies,
  sum(case when event_trigger='view' then 1 else 0 end) as views,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'query' and click_info['t5pos'] = '1') then 1 else 0 end) as yes,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'query' and click_info['t5pos'] = '2') then 1 else 0 end) as no,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'banner') then 1 else 0 end) as banner,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'social' and click_info['t5pos'] = '1') then 1 else 0 end) as Facebook,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'social' and click_info['t5pos'] = '2') then 1 else 0 end) as Line
 FROM
  venus_db.data
 WHERE
   dt between '20161112' and '20161120'
   AND spaceid='958806385'
   AND (page_info['thm_q'] = '1' or page_info['thm_u'] = '1')
  group by page_info['thm'], dt
  order by yes desc
;


//Per day (example output)
set mapreduce.map.memory.mb=4096;


SELECT
  dt,
  count(distinct bcookie) as bcookies,
  sum(case when event_trigger='view' then 1 else 0 end) as views,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'query' and click_info['t5pos'] = '1') then 1 else 0 end) as yes,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'query' and click_info['t5pos'] = '2') then 1 else 0 end) as no,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'banner') then 1 else 0 end) as banner,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'social' and click_info['t5pos'] = '1') then 1 else 0 end) as Facebook,
  sum(case when (event_trigger='click' and click_info['t2'] = 'sys_theme_select' and click_info['t4'] = 'social' and click_info['t5pos'] = '2') then 1 else 0 end) as Line
 FROM
  venus_db.data
 WHERE
   dt between '20161112' and '20161120'
   AND spaceid='958806385'
  AND (page_info['thm_q'] = '1' or page_info['thm_u'] = '1')
  group by dt
  order by yes desc
;
