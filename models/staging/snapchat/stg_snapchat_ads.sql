
with source_data as (

    select *
    from {{ source('snapchat', 'raw_snapchat_ads') }}

),

cleaned as (

    select
        cast(ad_id as string) as ad_id,
        cast(ad_group_id as string) as ad_group_id,
        cast(ad_name as string) as ad_name,
        cast(ad_detail_updated_at as timestamp) as ad_updated_at

    from source_data

)

select *
from cleaned
