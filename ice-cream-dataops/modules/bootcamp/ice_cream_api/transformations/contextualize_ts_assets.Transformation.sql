select
  timeseries.externalId,
  collect_set(node_reference("icapi_dm_space", assets.externalId)) as assets,
  timeseries.isStep,
  timeseries.type
from
  cdf_data_models("cdf_cdm", "CogniteCore", "v1", "CogniteTimeSeries") as timeseries
left join
  cdf_data_models("cdf_cdm", "CogniteCore", "v1", "CogniteAsset") as assets
ON
  split_part(timeseries.externalId, ":", 1) = assets.externalId
  and assets.space = "icapi_dm_space"
where
  timeseries.space = "icapi_dm_space"
group by
  timeseries.externalId,
  timeseries.isStep,
  timeseries.type