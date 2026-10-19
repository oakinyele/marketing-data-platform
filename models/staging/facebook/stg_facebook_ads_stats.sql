
with source_data as (

    select *
    from {{ source('facebook', 'raw_facebook_ads_stats') }}

),

cleaned as (

    select
        cast(ad_id as bigint) as ad_id,
        cast(account_id as bigint) as account_id,
        cast(ad_date as date) as ad_date,
        cast(ad_spend as double) as spend,

        try_cast(
            nullif(lower(trim(cast(ad_impressions as string))), 'null')
            as bigint
        ) as impressions,

        try_cast(
            nullif(lower(trim(cast(ad_clicks as string))), 'null')
            as bigint
        ) as clicks

    from source_data

)

select *
from cleaned
