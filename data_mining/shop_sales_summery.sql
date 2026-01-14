CREATE VIEW shop_sales_summery AS
SELECT 
    s.shop_sk,
    COUNT(*) AS num_sales,
    SUM(sale_amount) AS total_sales,
    AVG(sale_amount) AS avg_sales,
FROM fact_shop_sales s
GROUP BY s.shop_sk;