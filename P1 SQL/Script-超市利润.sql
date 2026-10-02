#日期转成 YYYY-MM-DD 格式
UPDATE sales SET order_date = substr(order_date,7,4)||'-'||substr(order_date,1,2)||'-'||substr(order_date,4,2);
UPDATE sales SET ship_date  = substr(ship_date,7,4)||'-'||substr(ship_date,1,2)||'-'||substr(ship_date,4,2);

SELECT order_date, ship_date FROM sales LIMIT 3;

#T1 每年销售额、利润、利润率
select substr(order_date, 1, 4) `年`,
       round(sum(sales),2) `利润`,
       concat(round(sum(profit)/nullif(sum(sales),0)*100.0,2),'%') `利润率`
from sales s 
group by  substr(order_date, 1, 4)
order by `年`;

#T2 每个 Category 的销售额、利润额、利润率，找出亏损品类
select category,
       round(sum(sales),2) `销售额`,
       round(sum(profit),2) `利润额`,
       concat(round(sum(profit)/nullif(sum(sales),0)*100.0,2),'%') `利润率`,
       case when round(sum(profit),2)<0
            then '亏损'
            else '正常'
       end `label`
from sales s 
where category is not NULL 
group by category
order by '利润额' desc; 

#T3 每个 Sub-Category 的利润率，列出亏损 TOP 3 和盈利 TOP 3
with `利润分析` as(
select sub_category,
       round(sum(profit),2) `利润额`,
       concat(round(sum(profit)/nullif(sum(sales),0)*100.0,2),'%') `利润率`,
       case when round(sum(profit),2)<0
            then '亏损'
            when round(sum(profit),2)>0
            then '盈利'
            else '不赚不亏'
       end label
from sales s 
group by sub_category
)
select *
from (select *,dense_rank() over(order by `利润额`) rk
      from `利润分析`
      where label='亏损'
) t1
where rk <= 3

union all

select *
from (select *,dense_rank() over(order by `利润额` desc) rk
      from `利润分析`
      where label='盈利'
) t2
where rk <= 3;    


#T4 Region → State 两级，找出亏损最严重的 3 个州
select *
from (select region,
             state,
             round(sum(profit),2) `利润额`
      from sales s
      group by region,state
) r
where `利润额`<0
order by `利润额`
limit 3;


#T5 找出全年哪几个月是旺季/淡季
select substr(order_date,6,2) `月`,
       round(sum(case when substr(order_date, 1, 4)='2015'
                      then sales
                      else 0
                 end),2) `2015销售额`,
       round(sum(case when substr(order_date, 1, 4)='2016'
                      then sales
                      else 0
                 end),2) `2016销售额`,    
       round(sum(case when substr(order_date, 1, 4)='2017'
                      then sales
                      else 0
                 end),2) `2017销售额`,
       round(sum(case when substr(order_date, 1, 4)='2018'
                      then sales
                      else 0
                 end),2) `2018销售额`
from sales s 
group by substr(order_date,6,2)
order by `月`;

#T6 不同 Discount 区间的订单数、平均利润率，验证"高折扣=亏损"假设
with p as (select discount,
                  count(order_id) `订单数`,
                  sum(profit)/nullif(sum(sales),0)*100.0 `利润率`
           from sales
           group by discount
)
select discount,`订单数`,
       concat(round(avg(利润率),2),'%') `平均利润率`
from p
group by discount;
       
#T7 Ship Date - Order Date 的平均天数，按 Ship Mode 分组
方法一
with t as(select ship_mode,
                 sum(julianday(ship_date)-julianday(order_date)) `发货天数`,
                 count(order_date) `订单数`
           from sales s 
           group by ship_mode
)
select ship_mode,
       round(`发货天数`*1.0/`订单数`,0) `发货平均天数`
from t
order by 发货平均天数;


方法二
select ship_mode,
       round(avg(julianday(ship_date) - julianday(order_date)), 0) as 发货平均天数
from sales
group by ship_mode
order by 发货平均天数;

#T8 窗口函数
a.按客户分组的订单累计消费（SUM OVER）
select 
    customer_id,order_date,sales,
    sum(sales) over(
        partition by customer_id 
        order by order_date 
        rows between unbounded preceding and current row
    ) as cumulative_sales
from sales
order by customer_id,order_date;

b.按 Sub-Category 的年度销售排名（DENSE_RANK）
select substr(order_date,1,4) year,
       sub_category,
       round(sum(sales),0) `年销售额`,
       dense_rank() over(partition by substr(order_date,1,4)
                         order by round(sum(sales),2) desc) `排名`
from sales
group by year,sub_category
order by year;

c.各州月度销售额的环比增长率（LAG）,
with monthly as (
select strftime('%Y-%m',order_date) ym,
       state,
       round(sum(sales), 2) monthly_sales
    from sales   
    group by ym,state
)
select ym,
       state,
       monthly_sales,
    lag(monthly_sales, 1) over(partition by state order by ym) prev_month,
    round((monthly_sales - lag(monthly_sales, 1) over(partition by state order by ym)) 
          / nullif(lag(monthly_sales, 1) over(partition by state order by ym),0) * 100.0, 2) `环比增长率`
from monthly
order by state,ym;


















