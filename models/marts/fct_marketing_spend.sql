with marketing_data as (

    select *
    from {{ ref('int_marketing_ads') }}

),

final as (

    select
        platform,
        ad_id,
        ad_name,
        ad_group_id,
        ad_group_name,
        campaign_id,
        campaign_name,
        account_id,
        account_name,
        currency_code,
        ad_date,
        country,
        data_source,

        spend,
        impressions,
        clicks,

        case
            when impressions > 0
                then clicks * 1.0 / impressions
            else null
        end as ctr,

        case
            when clicks > 0
                then spend / clicks
            else null
        end as cpc,

        case
            when impressions > 0
                then spend * 1000.0 / impressions
            else null
        end as cpm

    from marketing_data

)

select *
from final
