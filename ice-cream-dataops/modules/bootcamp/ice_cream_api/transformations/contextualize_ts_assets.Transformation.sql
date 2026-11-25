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
),
asset_matches as (
  select
    timeseries.externalId as timeseriesExternalId,
    node_reference("icapi_dm_space", assets.externalId) as asset
  from
    timeseries
  inner join
    cdf_data_models("cdf_cdm", "CogniteCore", "v1", "CogniteAsset") as assets
  ON
    split_part(timeseries.externalId, ":", 1) = assets.externalId
    and assets.space = "icapi_dm_space"
),
asset_references as (
  select
    timeseriesExternalId,
    collect_set(asset) as assets
  from
    asset_matches
  group by
    timeseriesExternalId
)
select
  timeseries.externalId,
  asset_references.assets,
  timeseries.isStep,
  timeseries.type
from
  timeseries
left join
  asset_references
ON
  timeseries.externalId = asset_references.timeseriesExternalId