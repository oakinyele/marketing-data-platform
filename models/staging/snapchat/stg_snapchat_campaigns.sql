with source_data as (
    select *
    from {{ source('snapchat', 'raw_snapchat_campaigns') }}
),

cleaned as (
    select
        cast(campaign_id as string) as campaign_id,
        cast(account_id as string) as account_id,
        cast(campaign_name as string) as campaign_name
    from source_data
)

select *
from cleaned
