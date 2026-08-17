# GoOutside data

The portfolio project uses four CSV source files that were loaded into BigQuery during the exercise.

Raw source data is intentionally not committed here. The repository documents the schema so the analytical workflow remains understandable without redistributing course data.

## `daily_sales`

149,257 rows.

| Column | Description |
|---|---|
| `Retailer code` | Retailer identifier |
| `Product number` | Product identifier |
| `Order method code` | Order-channel identifier |
| `Date` | Sale date |
| `Quantity` | Units sold |
| `Unit price` | Unit list/reference price |
| `Unit sale price` | Actual unit selling price |

Derived metric:

```text
Revenue = Quantity × Unit sale price
```

## `retailers`

562 rows.

| Column | Description |
|---|---|
| `Retailer code` | Retailer identifier |
| `Retailer name` | Retailer name |
| `Type` | Retailer type |
| `Country` | Market/country |

## `products`

274 rows.

| Column | Description |
|---|---|
| `Product number` | Product identifier |
| `Product line` | High-level product line |
| `Product type` | Product category/type |
| `Product` | Product name |
| `Product brand` | Brand |
| `Product color` | Color |
| `Unit cost` | Cost per unit |
| `Unit price` | Reference/list price |

Derived metric used for the Finance view:

```text
Gross Profit = Quantity × (Unit sale price − Unit cost)
```

## `order_methods`

12 reference rows; 7 order methods appear in sales activity.

| Column | Description |
|---|---|
| `Order method code` | Order-channel identifier |
| `Order method type` | Human-readable order-channel name |

Active channels in the project data are Web, Telephone, E-mail, Sales visit, Mail, Special and Fax.

## Join model

```text
                         products
                            │
                            │ Product number
                            ▼
retailers ── Retailer code ─ daily_sales ─ Order method code ─ order_methods
```

This structure lets the transaction table remain the central fact table while descriptive information lives in dimensions.
