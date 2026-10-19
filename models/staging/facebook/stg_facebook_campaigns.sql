with source_data as (
    select *
    from {{ source('facebook', 'raw_facebook_campaigns') }}
),

cleaned as (
    select
        cast(campaign_id as bigint) as campaign_id,
        cast(campaign_name as string) as campaign_name,
        cast(campaign_updated_at as timestamp) as campaign_updated_at
    from source_data
)

select *
from cleaned
