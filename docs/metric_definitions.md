# Metric definitions

This document records the main metrics used in the GoOutside dashboards and the calculation logic behind them.

## Revenue

```text
Revenue = Quantity × Unit sale price
```

Used for retailer, country and order-method performance.

Portfolio baseline: approximately **€1.252B**.

## Gross profit

```text
Gross Profit = Quantity × (Unit sale price − Unit cost)
```

Used in Sarah's Finance view.

Portfolio baseline: approximately **€527.7M**.

## Gross margin

```text
Gross Margin % = Total Gross Profit / Total Revenue × 100
```

Portfolio baseline: approximately **42.17%**.

### Aggregation note

Gross margin is a ratio and should not be summed across rows. The portfolio metric should be calculated from aggregated gross profit and aggregated revenue. A dashboard scorecard that sums or averages row-level percentage values can be misleading.

## Active retailers

Distinct retailers appearing in the sales fact table.

Portfolio baseline: **289 active retailers**.

## Countries

Distinct retailer countries represented in active sales.

Portfolio baseline: **21 countries**.

## Quantity sold

Sum of transaction quantity.

Portfolio baseline: approximately **19.80 million units**.

## Active order methods

Distinct order methods represented in sales.

Portfolio baseline: **7 active order methods**.

## Retailer concentration

The original dashboard provides retailer rankings and market-composition views. A stronger decision layer can calculate explicit concentration measures such as:

- top-3 retailer revenue share by country
- top-5 retailer revenue share by country
- Herfindahl-Hirschman Index (HHI)

These measures make Dustin's **big-player vs competitive market** classification more systematic.

The repository SQL includes a Top-3 retailer revenue-share query as the first explicit concentration measure.

## Channel economics limitation

The dataset contains product costs and sales revenue, allowing gross profit to be calculated. It does **not** include personnel or operating cost by order method.

Therefore Sarah's dashboard can identify low-volume / low-contribution channels, but a final phase-out recommendation would require additional cost-to-serve data.
