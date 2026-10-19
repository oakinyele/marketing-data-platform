# Marketing Data Platform

## Project Overview

This project uses dbt and Databricks to transform Facebook Ads and Snapchat Ads data into a unified marketing analytics model. It provides a consistent structure for analysing advertising performance across platforms, campaigns, ads, and dates.

The platform standardises source data, integrates available advertising metadata, calculates key performance metrics, and applies data-quality tests to support reliable reporting and downstream analytics.

## Architecture

The project follows a layered data transformation approach:

1. **Raw layer:** Source tables are maintained in the Databricks `workspace.default` schema.
2. **Staging layer:** Platform-specific models clean, cast, standardise, and deduplicate source data.
3. **Intermediate layer:** `int_marketing_ads` combines Facebook and Snapchat performance data and available advertising metadata.
4. **Mart layer:** `fct_marketing_spend` exposes the unified analytical dataset, including calculated performance metrics.
5. **Observability:** Elementary models capture dbt metadata and test results.

## Data Models

### Staging

Staging models are organised by platform:

- **Facebook:** accounts, ad groups, ads, ad statistics, and campaigns.
- **Snapchat:** ad groups, ads, ad statistics, and campaigns.

These models standardise fields and data types before integration.

### Intermediate

`int_marketing_ads` combines the two platforms into a common structure, retaining platform identifiers and available account, campaign, ad group, and ad metadata.

### Final Mart

`fct_marketing_spend` is the final analytical fact model. It includes advertising dimensions, reporting dates, source platform, currency, spend, impressions, clicks, and calculated performance metrics.

## Grain and Integration

The model grain is defined by the source performance data:

- **Facebook:** one row per ad per date.
- **Snapchat:** one row per ad per date per country.

The final model retains the platform and currency to preserve source context. Spend is not converted into a common currency, so cross-platform spend comparisons should account for currency differences.

Some metadata is not available consistently across both platforms. For example, the Snapchat source data does not include an account table, so account-level metadata is not populated for Snapchat records.

## Business Metrics

- **Spend:** Advertising spend reported by the source.
- **Impressions:** Number of reported ad impressions.
- **Clicks:** Number of reported ad clicks.
- **CTR (Click-Through Rate):** clicks divided by impressions.
- **CPC (Cost per Click):** spend divided by clicks.
- **CPM (Cost per Mille):** spend multiplied by 1,000 and divided by impressions.

Calculated metrics return null when their denominator is zero or unavailable.

## Data Quality and Testing

The project uses dbt tests and custom generic tests to validate data quality. Coverage includes:

- Required fields and non-null identifiers.
- Accepted platform values.
- Non-negative spend, impressions, and clicks.
- Uniqueness at the intended model grain.
- Composite-key uniqueness where applicable.
- Consistency of the final marketing fact model's grain.

Custom macros support non-negative value checks, composite-key uniqueness, and platform-aware grain validation.

## Materialization Strategy

- **Staging models:** views, keeping source-cleaning logic lightweight.
- **Intermediate model:** view, centralising reusable integration logic.
- **Final mart:** table, supporting repeated analytical queries without recalculating the complete transformation chain for every query.

Materialization choices should be reviewed against refresh frequency, data volume, query patterns, and warehouse cost.

## Technology Stack

- **Databricks:** Data platform and SQL warehouse.
- **dbt:** Data transformation, testing, documentation, and lineage.
- **Elementary:** dbt observability metadata and test-result models.
- **Git and GitHub Actions:** Source control and automated project validation.

## Setup and Usage

### Prerequisites

- Python and `uv`.
- dbt with the Databricks adapter.
- Access to the Databricks workspace and SQL warehouse.
- Appropriate permissions on the source tables.
- A dbt profile named `marketing_data_platform`.

### Install dependencies

From the project directory:

```bash
uv run dbt deps
```

### Validate the project

```bash
uv run dbt debug
uv run dbt parse
```

### Build models and run tests

```bash
uv run dbt build
```

### Generate documentation

```bash
uv run dbt docs generate
uv run dbt docs serve
```

The documentation site provides model descriptions, test information, and model lineage.

### Build Elementary models

```bash
uv run dbt run --select elementary
```

## Security and Environments

The local dbt profile is stored outside the repository at `~/.dbt/profiles.yml`. Credentials and access tokens must not be committed to source control.

The `.env.example` file documents the intended environment-variable configuration. It is a template and does not load variables automatically.

Production execution should use a Databricks Service Principal rather than a personal access token, with appropriately scoped Unity Catalog permissions. Development and production should use separate targets and schemas.

## CI/CD

The GitHub Actions workflow runs dependency installation and dbt project parsing on pull requests and pushes to `main`.

A production-ready workflow should extend this validation with warehouse-connected builds and tests, followed by controlled production deployment. This requires protected CI credentials, Databricks Service Principal configuration, and appropriate environment permissions.
