# Metric definitions

This document records the main metrics used in the GoOutside dashboards.

## Revenue

```text
Revenue = Quantity × Unit sale price
```

Used for retailer, country and order-method performance.

## Gross profit

```text
Gross Profit = Quantity × (Unit sale price − Unit cost)
```

Used in Sarah's Finance view.

## Gross margin

```text
Gross Margin % = Gross Profit / Revenue × 100
```

Portfolio baseline: approximately **42.17%**.

## Active retailers

Distinct retailers appearing in the sales fact table.

Portfolio baseline: **289 active retailers**.

## Countries

Distinct retailer countries represented in active sales.

Portfolio baseline: **21 countries**.

## Quantity sold

Sum of transaction quantity.

Portfolio baseline: approximately **19.8 million units**.

## Retailer concentration

The original dashboard provides rankings and market composition views. A stronger next iteration would calculate explicit concentration measures such as:

- top-3 retailer revenue share by country
- top-5 retailer revenue share by country
- Herfindahl-Hirschman Index (HHI)

These would make Dustin's 'big-player vs competitive market' classification more systematic.

## Channel economics limitation

The dataset contains product costs and sales revenue, allowing gross profit to be calculated. It does **not** include personnel or operating cost by order method.

Therefore Sarah's dashboard can identify low-volume / low-contribution channels, but a final phase-out recommendation would require additional cost-to-serve data.
