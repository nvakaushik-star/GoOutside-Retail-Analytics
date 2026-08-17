# Stakeholder Decision Framework

GoOutside was designed as a **stakeholder-specific BI product**, not a generic dashboard.

The same underlying warehouse supports two different decision workflows.

## Dustin — Head of Retail Partnerships

### Core question

Where should GoOutside focus partnership growth efforts across countries and retailers?

### What Dustin needs to see

- total revenue by country
- active retailers by country
- top retailers by revenue
- market composition
- retailer concentration

### Decision logic

The business case distinguishes between two broad market structures:

**Concentrated markets**

When a small number of retailers control a large share of sales, the commercial objective is to deepen existing partnerships and target approximately **10% additional sales volume per retailer**.

**Fragmented markets**

When sales are spread across many similarly-sized retailers, the commercial objective is to broaden market activity and target approximately **15% growth in active retailer count**.

### What the dashboard enables

The dashboard allows Dustin to filter by market, compare revenue and retailer presence, and identify whether a country appears dominated by large partners or distributed across many retailers.

A production version would formalize this using retailer revenue share or a concentration metric such as HHI rather than visual ranking alone.

---

## Sarah — Finance Manager

### Core question

Which order methods materially contribute to revenue and gross profit, and which channels deserve further cost-to-serve investigation?

### What Sarah needs to see

- revenue by order method
- gross profit by order method
- quantity sold by order method
- gross margin
- order-method filtering

### Decision logic

The current dataset contains commercial contribution but not personnel or operating cost by channel.

Therefore the dashboard does **not** claim that a channel should automatically be removed. Instead it identifies channels with low economic contribution that Finance should investigate further.

The analysis shows:

- Web dominates revenue and gross profit
- Telephone and E-mail form a meaningful second tier
- Sales visits contribute less, but still materially
- Mail, Special and Fax contribute relatively little revenue and volume

### What the dashboard enables

Sarah can compare order channels consistently and shortlist low-contribution methods for a deeper cost-to-serve review.

A production version would add channel staffing cost, fulfillment cost and service cost to calculate true channel profitability.

---

## Product-design takeaway

The important lesson from GoOutside is that **one warehouse can support multiple decision products**.

Dustin and Sarah use the same commercial data, but their questions, KPIs and actions are different.

That is why the project separates the dashboards rather than placing every metric into one overloaded report.
