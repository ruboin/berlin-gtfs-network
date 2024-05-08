# berlin-gtfs-network
 Visualization of Berlin's local transport (stations &amp; routes), incl. centrality measures from network analysis.
GTFS data was retrieved from https://daten.berlin.de/datensaetze/vbb-fahrplandaten-gtf (field descriptions: https://gtfs.org/schedule/reference/#field-definitions). The data is bounded to the shape of Berlin (https://daten.odis-berlin.de/de/dataset/bezirksgrenzen/). Therefore, measures are biased.
Centrality measures were computed with igraph and then min-max standardized (for correct visualization of the nodes' radii).
