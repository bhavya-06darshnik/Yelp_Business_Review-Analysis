-- 1. find number of businesses in each category.

with cte as (
    select business_id, trim(A.value) as category          --as we know categorie are given in comma separated way
    from tbl_yelp_businesses,
         lateral split_to_table(categorie, ',') A
    )
select category,count(*) as no_of_businesses
from cte
group by 1
order by 2 desc    --Restaurants is maximum as no. of businesses


--2. Find top 10 users who have reviewd the most businesses in 'Restaurants' category.

select r.user_id, count(distinct r.business_id)
from tbl_yelp_reviews r
         inner join tbl_yelp_businesses b on r.business_id=b.business_id
where b.categorie ilike '%restaurant%'
group by 1
order by 2 desc
limit 10

--3. Find most popular categories of businesses (based upon number of reviews)

with cte as (
    select business_id, trim(A.value) as category          --as we know categorie are given in comma separated way
    from tbl_yelp_businesses,
    lateral split_to_table(categorie, ',') A
    )
select category, count(*) as no_of_reviews
from cte
         inner join tbl_yelp_reviews r on cte.business_id=r.business_id
group by 1
order by 2 desc


--4. Find the top 3 most recent reviews for each business.

with cte as(
select r.*,b.name,
row_number() over(partition by r.business_id order by review_date desc)as rn
from tbl_yelp_reviews r
inner join tbl_yelp_businesses b on r.business_id=b.business_id
)
select * from cte
where rn<=3