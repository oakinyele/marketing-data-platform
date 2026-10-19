
with source_data as (

    select *
    from {{ source('snapchat', 'raw_snapchat_ads_stats') }}

),

cleaned as (

    select
        cast(ad_detail_id as string) as ad_id,
        cast(ad_date as date) as ad_date,
        cast(ad_country as string) as country,
        cast(ad_currency_code as string) as currency_code,
        cast(data_src as string) as data_source,
        cast(ad_spend as double) as spend,
        cast(ad_impressions as bigint) as impressions,

        try_cast(
            nullif(lower(trim(cast(ad_clicks as string))), 'null')
            as bigint
        ) as clicks

    from source_data

)

select *
from cleaned
