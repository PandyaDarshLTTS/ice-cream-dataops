with timeseries as (
  select
    externalId,
    max(isStep) as isStep,
    max(type) as type
  from
    cdf_data_models("cdf_cdm", "CogniteCore", "v1", "CogniteTimeSeries")
  where
    space = "icapi_dm_space"
  group by
    externalId
)
select
  timeseries.externalId,
  collect_set(node_reference("icapi_dm_space", assets.externalId)) as assets,
  max(timeseries.isStep) as isStep,
  max(timeseries.type) as type
from
  timeseries
left join
  cdf_data_models("cdf_cdm", "CogniteCore", "v1", "CogniteAsset") as assets
ON
  split_part(timeseries.externalId, ":", 1) = assets.externalId
  and assets.space = "icapi_dm_space"
group by
  timeseries.externalId