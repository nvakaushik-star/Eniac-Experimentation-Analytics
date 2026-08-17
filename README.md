# Eniac Experimentation Analytics

**E-commerce strategy, market-entry analysis, SQL exploration and experimentation thinking**

This project analyzes the **Magist** marketplace dataset to evaluate whether Eniac — a premium technology retailer — should consider Magist as a potential partner for entering the Brazilian market.

The work combines SQL analysis, market context, pricing research and business interpretation to answer two questions:

1. **Does Magist have enough demand and seller activity in technology categories to support Eniac's positioning?**
2. **Can Magist's operational performance support the customer experience expected from a premium-tech retailer?**

## Business context

Eniac sells premium technology products and is evaluating expansion into Brazil. Magist offers an established marketplace infrastructure, but Eniac needs evidence that the platform can support both commercial performance and a premium customer experience.

The analysis therefore focuses on:

- size and activity of the marketplace
- technology-category demand
- customer interest in expensive technology products
- seller economics
- order and delivery performance
- implications for a premium-tech market-entry strategy

## SQL analysis

The exploratory SQL covers:

- total order volume and delivery completion
- monthly order trends
- product and category structure
- price and payment ranges
- definition of technology-related categories
- share of tech products sold
- percentile-based analysis of expensive tech products
- seller counts and seller concentration
- tech seller revenue and average monthly income
- delivery speed and on-time performance
- relationship between shipment weight and delivery delays

The full SQL script is available in [`sql/eniac_magist_analysis.sql`](sql/eniac_magist_analysis.sql).

## Key findings

| Metric | Result |
|---|---:|
| Orders | 99,441 |
| Delivered orders | ~97% |
| Products | 32,951 |
| Products sold | 112,650 |
| Tech products sold | 16,935 |
| Tech share of products sold | 15.03% |
| Total seller earnings | €13.59M |
| Tech seller earnings | €1.84M |
| Tech share of seller earnings | 13.51% |
| Sellers | 3,095 |
| Tech sellers | 477 |
| Average monthly seller income | €826.28 |
| Average monthly tech-seller income | €792.09 |
| Average delivery time | 12 days |
| Orders delivered on time | 89.15% |
| Delayed orders | 7.87% |

A notable customer-demand finding was that only **2.24% of historical customers** purchased expensive technology products when "expensive" was defined as the 85th price percentile and above within the selected tech categories.

## Business interpretation

The analysis suggested that Magist had a meaningful technology assortment and active seller base, but premium-tech demand appeared relatively narrow. Tech products represented around **15% of units sold** and **13.5% of seller earnings**, while high-priced tech purchases were concentrated among a small share of customers.

Operationally, delivery performance was reasonably strong overall, with around **89% of orders delivered on or before the estimated date**, though the average customer wait was around **12 days**. Shipment weight did not appear to explain delivery delays in the tested comparison.

For a premium retailer such as Eniac, these findings imply that market entry should not be judged only on marketplace size. The decision also depends on whether the platform can support:

- premium-product positioning
- reliable delivery expectations
- sufficient high-value customer demand
- seller/service quality consistent with the Eniac brand

## Market context

The project also considered the Brazilian e-commerce environment around 2018, where consumer electronics demand was strong but premium imported devices were expensive relative to local purchasing power. Taxes, import costs and currency effects made premium technology an aspirational purchase for many consumers.

This context strengthens the interpretation of the Magist data: a large marketplace can still have a relatively narrow customer segment for expensive technology products.

## Project structure

```text
Eniac-Experimentation-Analytics/
├── sql/
│   └── eniac_magist_analysis.sql
├── docs/
│   └── market_context.md
├── README.md
└── .gitignore
```

## Skills demonstrated

**SQL · CTEs · joins · window functions · percentile analysis · aggregation · business analysis · market research · e-commerce analytics · product strategy**

## Limitations

- The Magist data represents a historical marketplace snapshot and does not measure current Brazilian e-commerce conditions.
- The selected technology categories are an analytical approximation based on category names.
- The expensive-product threshold is a business rule based on the 85th percentile, not an externally defined premium-price standard.
- Marketplace performance alone cannot fully determine whether a partnership would meet Eniac's brand, operational and strategic requirements.

## Product / strategy takeaway

> **A marketplace can be commercially large without necessarily being the right distribution partner for a premium technology brand.**

This case study demonstrates how SQL analysis can move beyond descriptive reporting and support a strategic market-entry decision.

---

### Author

**Koushik Nimmagadda**  
Product / Data Analytics portfolio case study
