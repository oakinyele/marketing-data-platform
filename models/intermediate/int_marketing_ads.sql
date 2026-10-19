with facebook_performance as (

    select
        'facebook' as platform,
        cast(stats.ad_id as string) as ad_id,
        cast(ads.ad_name as string) as ad_name,
        cast(ads.ad_group_id as string) as ad_group_id,
        cast(adgroups.ad_group_name as string) as ad_group_name,
        cast(ads.campaign_id as string) as campaign_id,
        campaigns.campaign_name as campaign_name,
        cast(stats.account_id as string) as account_id,
        accounts.account_name as account_name,
        accounts.currency_code as currency_code,
        stats.ad_date as ad_date,
        cast(null as string) as country,
        cast(stats.spend as double) as spend,
        cast(stats.impressions as bigint) as impressions,
        cast(stats.clicks as bigint) as clicks,
        cast(null as string) as data_source

    from {{ ref('stg_facebook_ads_stats') }} as stats

    left join {{ ref('stg_facebook_ads') }} as ads
        on stats.ad_id = ads.ad_id

    left join {{ ref('stg_facebook_adgroups') }} as adgroups
        on ads.ad_group_id = adgroups.ad_group_id

    left join {{ ref('stg_facebook_campaigns') }} as campaigns
        on ads.campaign_id = campaigns.campaign_id

    left join {{ ref('stg_facebook_accounts') }} as accounts
        on stats.account_id = accounts.account_id
),

snapchat_performance as (

    select
        'snapchat' as platform,
        cast(stats.ad_id as string) as ad_id,
        ads.ad_name as ad_name,
        cast(ads.ad_group_id as string) as ad_group_id,
        adgroups.ad_group_name as ad_group_name,
        cast(adgroups.campaign_id as string) as campaign_id,
        campaigns.campaign_name as campaign_name,
        cast(campaigns.account_id as string) as account_id,
        cast(null as string) as account_name,
        stats.currency_code as currency_code,
        stats.ad_date as ad_date,
        stats.country as country,
        cast(stats.spend as double) as spend,
        cast(stats.impressions as bigint) as impressions,
        cast(stats.clicks as bigint) as clicks,
        stats.data_source as data_source

    from {{ ref('stg_snapchat_ads_stats') }} as stats

    left join {{ ref('stg_snapchat_ads') }} as ads
        on stats.ad_id = ads.ad_id

    left join {{ ref('stg_snapchat_adgroups') }} as adgroups
        on ads.ad_group_id = adgroups.ad_group_id

    left join {{ ref('stg_snapchat_campaigns') }} as campaigns
        on adgroups.campaign_id = campaigns.campaign_id
)

select * from facebook_performance

union all

select * from snapchat_performance
