
with source_data as (

    select *
    from {{ source('facebook', 'raw_facebook_ads') }}

),

cleaned as (

    select
        cast(ad_id as bigint) as ad_id,
        cast(campaign_id as bigint) as campaign_id,
        cast(ad_group_id as bigint) as ad_group_id,
        cast(account_id as bigint) as account_id,
        cast(ad_name as string) as ad_name,
        cast(ad_status as string) as ad_status,
        cast(ad_updated_at as timestamp) as ad_updated_at

    from source_data

)

select *
from cleaned
