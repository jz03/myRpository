-- 热点信息
select id,query,`desc`,create_date from hot_info ORDER BY	id DESC

-- 抓取查询
SELECT	branch_id,create_date FROM	hot_branch 
GROUP BY	branch_id ORDER BY	branch_id DESC
-- 综合消息
select b.id,`index`,hot_score,`query`,`desc`,a.create_date,b.create_date as info_date from hot_branch a,hot_info b 
where a.hot_info_id=b.id and a.branch_id='1635946060527'

select b.id,`index`,hot_score,`query`,`desc`,a.create_date from hot_branch a,hot_info b 
where a.hot_info_id=b.id and b.query like '%郑州一小学4人检出阳性%'


