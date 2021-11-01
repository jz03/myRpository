select branch_id,`index`,hot_score,query,`desc`,record_date  from hot_search_info where query='为什么付尾款总在半夜' ORDER BY record_date desc

select *  from hot_search_info where branch_id='1635734353878'
-- 降序查询
select branch_id  from hot_search_info GROUP BY branch_id ORDER BY branch_id desc