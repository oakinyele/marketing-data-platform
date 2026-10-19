
with source_data as (

    select *
    from {{ source('snapchat', 'raw_snapchat_adgroups') }}

),

ranked as (

    select
        cast(_surrogate_key as string) as surrogate_key,
        cast(ad_group_id as string) as ad_group_id,
        cast(campaign_id as string) as campaign_id,
        cast(ad_group_name as string) as ad_group_name,
        cast(ad_group_updated_at as timestamp) as ad_group_updated_at,

        row_number() over (
            partition by ad_group_id
            order by ad_group_updated_at desc, _surrogate_key desc
        ) as row_num

    from source_data

)

select
    surrogate_key,
    ad_group_id,
    campaign_id,
    ad_group_name,
    ad_group_updated_at
from ranked
where row_num = 1
