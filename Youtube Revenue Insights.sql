CREATE DATABASE youtube_project;
USE youtube_project;
CREATE TABLE youtube_channels (
    Creator_Id VARCHAR(20) PRIMARY KEY,
    Channel_name VARCHAR(100),
    Category VARCHAR(50),
    Region VARCHAR(50),
    Total_views BIGINT,
    Watch_hours FLOAT,
    Ad_Clicks INT,
    Ad_Type VARCHAR(50),
    Revenue_USD FLOAT,
    Upload_Frequency VARCHAR(50),
    Engagement_rate FLOAT,
    Date DATE
);
SELECT * FROM youtube_channels LIMIT 5;
-- ================================================

## INSIGHT 1: Top Revenue Generating Channels
SELECT 
    Channel_name, 
    Category, 
    Region, 
    Revenue_USD
FROM youtube_channels
ORDER BY Revenue_USD DESC
LIMIT 5;SELECT 
    Channel_name, 
    Category, 
    Region, 
    Revenue_USD
FROM youtube_channels
ORDER BY Revenue_USD DESC
LIMIT 5;

-- 💡 Summary:
-- Top revenue-generating channels span diverse categories—Music, Technology, Education, Food, and Lifestyle—across multiple regions including Indonesia, the UK, India, South Korea, and the US. 
-- This indicates that high monetization is not limited to one niche or region, highlighting the global and category-diverse nature of YouTube revenue opportunities.
-- ==================================================


## INSIGHT 2: Top Performing channels by Views
SELECT Channel_name, Category, Region, Total_views
FROM youtube_channels
ORDER BY Total_views DESC
LIMIT 10;

--  💡 Summary: 
-- Lifestyle channels dominate the top view rankings, particularly in the United Kingdom, Japan, and Canada, indicating strong global appeal.
--  Music, Gaming, Food, and Technology also feature prominently, showing that high-viewership is spread across multiple popular niches. 
-- The data suggests that Lifestyle content consistently attracts large audiences internationally, while other categories maintain strong regional engagement.
-- =========================================================


## INSIGHT 3: Regional Revenue Efficiency
SELECT 
    Region,
    Category,
    ROUND(SUM(Revenue_USD), 2) AS Total_Revenue,
    ROUND(AVG(Revenue_USD), 2) AS Avg_Revenue_per_Channel
FROM youtube_channels
GROUP BY Region, Category
ORDER BY Region, Total_Revenue DESC;

-- 💡 Summary: 
-- Revenue patterns differ drastically by region: Gaming dominates Southeast Asia, Food and Lifestyle shine in Brazil and India, while Music and Lifestyle lead in the US and UK.
-- This highlights the importance of region-specific content and ad strategies, offering actionable insights for platform growth and targeted monetization.
-- ==========================================================


## INSIGHT 4: Seasonal/Date-Based Trends
SELECT 
    EXTRACT(MONTH FROM Date) AS Month,
    Category,
    SUM(Total_views) AS Views,
    SUM(Revenue_USD) AS Revenue
FROM youtube_channels
GROUP BY Month, Category
ORDER BY Month, Revenue DESC;

-- 💡 Summary: 
-- Gaming, Music, and Technology channels consistently attract high views and watch hours throughout the year, showing stable audience demand. 
-- Lifestyle, Food, and Education content display clear seasonal patterns, with spikes likely tied to holidays, cultural events, or academic cycles. 
-- Strategically aligning content releases with these periods can enhance engagement, retention, and revenue. 
-- Overall, understanding these seasonal trends helps creators and platforms optimize scheduling, ad placement, and niche targeting for maximum impact.
-- ===========================================================


## INSIGHT 5 — Watch-Time Engagement Gap
SELECT 
    Channel_name,
    Category,
    Total_views,
    Watch_hours,
    ROUND(Watch_hours/Total_views, 2) AS Avg_Hours_per_View,
    Engagement_rate
FROM youtube_channels
ORDER BY (Watch_hours/Total_views) DESC, Engagement_rate DESC
LIMIT 10;

-- 💡 Summary: 
-- Channels like Gaming (199) and Food (134) show the highest watch hours per view combined with strong engagement, indicating highly engaging content that retains viewers.
-- Lifestyle and Music channels also perform well, though some Education and Food channels achieve moderate watch efficiency with lower engagement. 
-- Overall, high watch-time per view paired with engagement identifies channels with strong content retention and growth potential, even if total views are moderate.
-- ==================================================================


## INSIGHT 6: Ad Performance by Ad type and Ad clicks
-- Total ad clicks and revenue by ad type
SELECT Ad_Type, SUM(Ad_Clicks) AS Total_Clicks, SUM(Revenue_USD) AS Total_Revenue
FROM youtube_channels
GROUP BY Ad_Type
ORDER BY Total_Revenue DESC;

-- Channels with highest revenue per ad click
SELECT Channel_name, Revenue_USD, Ad_Clicks, Revenue_USD/Ad_Clicks AS Revenue_Per_Click
FROM youtube_channels
WHERE Ad_Clicks > 0
ORDER BY Revenue_Per_Click DESC
LIMIT 10;
    
-- 💡 Summary: 
-- Sponsored Cards generate the highest total revenue, followed by Display and Non-Skippable Video ads, indicating these formats are the most effective across channels. 
-- At the individual channel level, Music, Food, Gaming, and Lifestyle creators show varying revenue efficiencies, with some smaller channels outperforming larger ones in revenue per ad click. 
-- This highlights that ad type and content niche strongly influence monetization performance, and tailoring ads to channel category can maximize revenue.
-- ================================================================


## INSIGHT 7: Optimal Upload Frequency vs Revenue Efficiency
SELECT 
    Upload_Frequency,
    COUNT(DISTINCT Creator_Id) AS Num_Creators,
    SUM(Revenue_USD) AS Total_Revenue,
    SUM(Total_views) AS Total_Views,
    SUM(Watch_hours) AS Total_Watch_Hours,
    SUM(Revenue_USD)/SUM(Watch_hours) AS Revenue_per_Hour,
    SUM(Revenue_USD)/SUM(Total_views) AS Revenue_per_View,
    AVG(Engagement_rate) AS Avg_Engagement
FROM youtube_channels
GROUP BY Upload_Frequency
ORDER BY Revenue_per_Hour DESC;

-- 💡 Summary:
-- Higher upload frequency doesn’t always mean higher revenue or engagement.
-- Moderate-frequency channels often achieve better balance of revenue, views, and engagement.
-- Strategic scheduling and quality content outperform sheer quantity.
-- ============================================


## INSIGHT 8: Growth Potential Analysis
SELECT 
    Channel_name,
    Category,
    Total_views,
    Watch_hours,
    Engagement_rate,
    ROUND(Engagement_rate * (Watch_hours/Total_views), 2) AS Potential_Score
FROM youtube_channels
ORDER BY Potential_Score DESC
LIMIT 10;

-- 💡 Summary:
-- Gaming and Food channels show the highest growth potential, combining strong engagement with efficient watch hours. 
-- Some Lifestyle and Music channels, despite moderate views, also demonstrate notable potential due to high engagement rates. 
-- Overall, channels with high engagement × watch-time efficiency—not just total views—represent the best opportunities for future growth.
-- ==============================================


## INSIGHT 9: Identify Underperforming High-View Channels
-- Step 1: Calculate watch efficiency and engagement per channel
WITH efficiency AS (
    SELECT 
        Creator_Id,
        Channel_name,
        Category,
        Region,
        Total_views,
        Watch_hours,
        Engagement_rate,
        ROUND(Watch_hours / Total_views, 4) AS Watch_Hours_per_View
    FROM youtube_channels
)

-- Step 2: Filter channels with high views but low efficiency and limit to top 10
SELECT *
FROM efficiency
WHERE Total_views >= 50000         -- high view threshold
  AND (Watch_Hours_per_View < 0.2 OR Engagement_rate < 0.05)  -- underperforming thresholds
ORDER BY Total_views DESC
LIMIT 10;  -- only top 10

-- 💡 Summary: 
-- The top 10 underperforming high-view channels, each with ~1.96–1.99M views, show very low watch hours per view (0.0009–0.0076) and mostly low engagement rates (0.001–0.01), 
-- spanning Lifestyle, Food, Music, Gaming, and Technology categories across regions like the UK, Japan, Canada, the US, and South Korea.
-- Despite high visibility, these channels struggle to retain viewers or drive interactions, highlighting the need for content optimization and category-specific monetization strategies to improve engagement and overall performance.
-- ==============================================================


## INSIGHT 10:  Predictive Content Planning 
-- Step 1: Aggregate monthly performance by category
SELECT
    EXTRACT(MONTH FROM Date) AS Month,
    Category,
    SUM(Total_views) AS Total_Views,
    SUM(Watch_hours) AS Total_Watch_Hours,
    ROUND(SUM(Watch_hours)/SUM(Total_views),2) AS Avg_Hours_per_View
FROM youtube_channels
GROUP BY Month, Category
ORDER BY Month, Total_Watch_Hours DESC;

-- Step 2: Identify top categories per month for predictive planning
WITH monthly_category AS (
    SELECT
        EXTRACT(MONTH FROM Date) AS Month,
        Category,
        SUM(Total_views) AS Total_Views,
        SUM(Watch_hours) AS Total_Watch_Hours,
        ROUND(SUM(Watch_hours)/SUM(Total_views),2) AS Avg_Hours_per_View
    FROM youtube_channels
    GROUP BY Month, Category
),
ranked_monthly AS (
    SELECT 
        Month,
        Category,
        Total_Views,
        Total_Watch_Hours,
        Avg_Hours_per_View,
        RANK() OVER (PARTITION BY Month ORDER BY Total_Watch_Hours DESC) AS Rank_by_Watch_Hours
    FROM monthly_category
)
SELECT *
FROM ranked_monthly
WHERE Rank_by_Watch_Hours <= 3   -- top 3 categories per month
ORDER BY Month, Rank_by_Watch_Hours;

-- 💡 Summary: 
-- Early in the year, Technology, Music, and Education dominate viewer attention, whereas Gaming, Food, and Lifestyle gain traction in mid-to-late months. 
-- Watch hours remain high across all top categories, but the average watch hours per view (0.01–0.02) indicates that audiences tend to view a small portion of content consistently.
-- This pattern highlights clear seasonal trends, suggesting creators can optimize content release schedules to align with audience interest peaks and maximize watch hours, engagement, and revenue throughout the year.
-- =========================================================
