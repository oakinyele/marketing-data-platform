with source_data as (
    select *
    from {{ source('facebook', 'raw_facebook_accounts') }}
),

cleaned as (
    select
        cast(account_id as bigint) as account_id,
        cast(account_name as string) as account_name,
        cast(ad_currency_code as string) as currency_code,
        cast(account_created_at as timestamp) as account_created_at,
        cast(account_updated_at as timestamp) as account_updated_at
    from source_data
)

select *
from cleaned
