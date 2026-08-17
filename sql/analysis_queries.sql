-- GoOutside Retail Analytics
-- Portfolio reconstruction of the stakeholder analysis using the project schema.
-- Replace `project.dataset` with the BigQuery project/dataset used in your environment.

-- ============================================================
-- 1. Reusable joined sales view
-- ============================================================

WITH sales_enriched AS (
  SELECT
    s.`Retailer code` AS retailer_code,
    r.`Retailer name` AS retailer_name,
    r.`Type` AS retailer_type,
    r.`Country` AS country,
    s.`Product number` AS product_number,
    p.`Product line` AS product_line,
    p.`Product type` AS product_type,
    p.`Product` AS product_name,
    s.`Order method code` AS order_method_code,
    m.`Order method type` AS order_method_type,
    PARSE_DATE('%d/%m/%Y', s.`Date`) AS sale_date,
    s.`Quantity` AS quantity,
    s.`Unit sale price` AS unit_sale_price,
    p.`Unit cost` AS unit_cost,
    s.`Quantity` * s.`Unit sale price` AS revenue,
    s.`Quantity` * (s.`Unit sale price` - p.`Unit cost`) AS gross_profit
  FROM `project.dataset.Daily_sales` AS s
  LEFT JOIN `project.dataset.Retailers` AS r
    ON s.`Retailer code` = r.`Retailer code`
  LEFT JOIN `project.dataset.Products` AS p
    ON s.`Product number` = p.`Product number`
  LEFT JOIN `project.dataset.Methods` AS m
    ON s.`Order method code` = m.`Order method code`
)
SELECT *
FROM sales_enriched;

-- ============================================================
-- 2. Executive portfolio KPIs
-- ============================================================

WITH sales_enriched AS (
  SELECT
    s.`Retailer code` AS retailer_code,
    r.`Country` AS country,
    m.`Order method type` AS order_method_type,
    s.`Quantity` AS quantity,
    s.`Quantity` * s.`Unit sale price` AS revenue,
    s.`Quantity` * (s.`Unit sale price` - p.`Unit cost`) AS gross_profit
  FROM `project.dataset.Daily_sales` AS s
  LEFT JOIN `project.dataset.Retailers` AS r
    ON s.`Retailer code` = r.`Retailer code`
  LEFT JOIN `project.dataset.Products` AS p
    ON s.`Product number` = p.`Product number`
  LEFT JOIN `project.dataset.Methods` AS m
    ON s.`Order method code` = m.`Order method code`
)
SELECT
  COUNT(DISTINCT retailer_code) AS active_retailers,
  SUM(quantity) AS total_quantity_sold,
  COUNT(DISTINCT country) AS countries,
  SUM(revenue) AS total_revenue,
  SUM(gross_profit) AS gross_profit,
  SAFE_DIVIDE(SUM(gross_profit), SUM(revenue)) * 100 AS gross_margin_pct,
  COUNT(DISTINCT order_method_type) AS active_order_methods
FROM sales_enriched;

-- ============================================================
-- 3. Dustin: top retailers by revenue
-- ============================================================

SELECT
  r.`Retailer name` AS retailer_name,
  r.`Country` AS country,
  SUM(s.`Quantity` * s.`Unit sale price`) AS revenue
FROM `project.dataset.Daily_sales` AS s
LEFT JOIN `project.dataset.Retailers` AS r
  ON s.`Retailer code` = r.`Retailer code`
GROUP BY retailer_name, country
ORDER BY revenue DESC
LIMIT 10;

-- ============================================================
-- 4. Dustin: country performance and active-retailer count
-- ============================================================

SELECT
  r.`Country` AS country,
  COUNT(DISTINCT s.`Retailer code`) AS active_retailers,
  SUM(s.`Quantity`) AS quantity_sold,
  SUM(s.`Quantity` * s.`Unit sale price`) AS revenue
FROM `project.dataset.Daily_sales` AS s
LEFT JOIN `project.dataset.Retailers` AS r
  ON s.`Retailer code` = r.`Retailer code`
GROUP BY country
ORDER BY revenue DESC;

-- ============================================================
-- 5. Dustin: suggested concentration metric
--    Top-3 retailer revenue share by country
-- ============================================================

WITH retailer_revenue AS (
  SELECT
    r.`Country` AS country,
    r.`Retailer name` AS retailer_name,
    SUM(s.`Quantity` * s.`Unit sale price`) AS retailer_revenue
  FROM `project.dataset.Daily_sales` AS s
  LEFT JOIN `project.dataset.Retailers` AS r
    ON s.`Retailer code` = r.`Retailer code`
  GROUP BY country, retailer_name
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY country
      ORDER BY retailer_revenue DESC
    ) AS revenue_rank,
    SUM(retailer_revenue) OVER (PARTITION BY country) AS country_revenue
  FROM retailer_revenue
)
SELECT
  country,
  COUNT(*) AS active_retailers,
  SUM(IF(revenue_rank <= 3, retailer_revenue, 0)) AS top3_revenue,
  MAX(country_revenue) AS country_revenue,
  SAFE_DIVIDE(
    SUM(IF(revenue_rank <= 3, retailer_revenue, 0)),
    MAX(country_revenue)
  ) * 100 AS top3_revenue_share_pct
FROM ranked
GROUP BY country
ORDER BY top3_revenue_share_pct DESC;

-- ============================================================
-- 6. Sarah: order-method contribution
-- ============================================================

SELECT
  m.`Order method type` AS order_method_type,
  COUNT(*) AS transaction_rows,
  SUM(s.`Quantity`) AS quantity_sold,
  SUM(s.`Quantity` * s.`Unit sale price`) AS revenue,
  SUM(s.`Quantity` * (s.`Unit sale price` - p.`Unit cost`)) AS gross_profit,
  SAFE_DIVIDE(
    SUM(s.`Quantity` * (s.`Unit sale price` - p.`Unit cost`)),
    SUM(s.`Quantity` * s.`Unit sale price`)
  ) * 100 AS gross_margin_pct
FROM `project.dataset.Daily_sales` AS s
LEFT JOIN `project.dataset.Methods` AS m
  ON s.`Order method code` = m.`Order method code`
LEFT JOIN `project.dataset.Products` AS p
  ON s.`Product number` = p.`Product number`
GROUP BY order_method_type
ORDER BY revenue DESC;

-- Important limitation:
-- Personnel / operating cost by order method is not present in the supplied data.
-- These queries show contribution and gross profit, but cannot calculate
-- true channel profitability or justify a phase-out decision on their own.
