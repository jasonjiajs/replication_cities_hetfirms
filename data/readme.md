# Data sources

## 1. Exports
- https://www.trade.gov/data-visualization/metropolitan-export-map 
- → All MSA Exports Map (2012 - 2021) → Choose a format to download 
- → Crosstab → Table, csv → Download
- → `exports_ita.csv`

## 2. Population
- https://www.census.gov/data/tables/time-series/demo/popest/2010s-total-metro-and-micro-statistical-areas.html
- → Annual Estimates of the Resident Population: April 1, 2010 to July 1, 2019 
- → Metropolitan Statistical Area; and for Puerto Rico [<1.0 MB]
- → `cbsa-met-est2019-annres.xlsx`

## 3. MSA Crosswalk
- https://www.census.gov/geographies/reference-files/time-series/demo/metro-micro/delineation-files.html
- → Core based statistical areas (CBSAs), metropolitan divisions, and combined statistical areas (CSAs) 
- → Feb. 2013 [<1.0 MB] → resaved as .csv file
- → `msa_crosswalk.csv`

## 4. Sales
- https://www.census.gov/data/datasets/2012/econ/census/2012-core-reports.html
- → Geographic Area Series → All Geographies → ec1200a1.zip
- → `EC1200A1.dat`

## 5. Land area
- https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.2012.html#list-tab-790442341 (TIGER/Line Shapefiles, 2012) 
- → FTP Archive → CBSA/ → tl_2012_us_cbsa.zip (https://www2.census.gov/geo/tiger/TIGER2012/CBSA/)
- → `tl_2012_us_cbsa/tl_2012_us_cbsa.shp`
- Documentation: https://www.census.gov/programs-surveys/geography/technical-documentation/complete-technical-documentation/tiger-geo-line.2012.html#list-tab-240499709 (TIGER/Line Shapefiles and TIGER/Line Files Technical Documentation → 2012 → Chapter 5 - Geographic Shapefile Concepts Overview [<1.0 MB] (https://www2.census.gov/geo/pdfs/maps-data/data/tiger/tgrshp2012/TGRSHP2012_TechDoc_Ch5.pdf)
- Not used, only for reference: Cartographic Boundary Files - Shapefiles, https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
- Units for land area is square meters: https://www.census.gov/quickfacts/fact/note/US/LND110210
 
## 6. Local industry shares
- https://www.bea.gov/data/employment/employment-county-metro-and-other-areas (Employment by County, Metro, and Other Areas)
- → Interactive Tables: Employment by county and MSA → PERSONAL INCOME AND EMPLOYMENT BY COUNTY AND METROPOLITAN AREA → Total full-time and part-time employment by industry → NAICS (2001-forward) → Metropolitan Statistical Area → Area: All Areas, Statistic: All statistics in table, Unit of measure: Levels, Time period: 2012) → Download → CSV → Table.csv (rename as employment_by_industry.csv)
- → `employment_by_industry.csv`

## Misc 
- County population (2012): https://www.census.gov/data/tables/time-series/demo/popest/2010s-counties-total.html (Annual Estimates of the Resident Population for Counties: April 1, 2010 to July 1, 2019 → United States → co-est2019-annres.xlsx)
- County info with population and land area (2011): https://www.census.gov/library/publications/2011/compendia/usa-counties-2011.html