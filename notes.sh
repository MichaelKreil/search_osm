# 1. OSM-PBF-Datei von http://download.geofabrik.de/europe/germany.html runterladen:
wget http://download.geofabrik.de/europe/germany-latest.osm.pbf
# Anmerkung: Mit PBF (Google Protocol Buffers) schafft OSM, die komplexe XML-Datenbank sehr klein zu komprimieren

# 2. Mit GDAL ogr2ogr PBF in SQLite konvertieren. Dabei die osmconf.ini verwenden
ogr2ogr --config OSM_CONFIG_FILE osmconf.ini -f SQLite germany.sqlite germany-latest.osm.pbf -progress
# ogr2ogr konvertiert nodes, ways und relation in der OSM-Datenbank zu points, lines, polygons, ...

# 3. Mit ogr2ogr kann man nun SQL-Queries ausführen und die Ergebnisse bspw. als GeoJSON speichern
ogr2ogr -f GeoJSON schools.geojson germany.sqlite -sql "SELECT *, NULL as 'osm_way_id', 'point' as 'table' FROM points WHERE amenity LIKE 'school' UNION SELECT *, NULL as 'osm_way_id', 'line' as 'table' FROM lines WHERE amenity LIKE 'school' UNION SELECT *, NULL as 'osm_way_id', 'multilinestring' as 'table' FROM multilinestrings WHERE amenity LIKE 'school' UNION SELECT *, NULL as 'osm_way_id', 'other_relation' as 'table' FROM other_relations WHERE amenity LIKE 'school' UNION SELECT *, 'multipolygon' as 'table' FROM multipolygons WHERE amenity LIKE 'school';"

# 4. Im letzten Schritt kann man das GeoJSON-Extract weiter säubern
# Insbesondere können z.B. Schulen als Punkte oder Polygon gespeichert werden.
# Mit einem Script sollte man alles auf Punkte umrechnen und benachbarte Punkte zusammenfassen.
