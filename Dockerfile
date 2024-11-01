# Use an official OSRM image
FROM ghcr.io/project-osrm/osrm-backend:latest

# Set the working directory
WORKDIR /data

# Install wget
RUN apt-get update && apt-get install -y wget

# Download the OSM data file for Vietnam
RUN wget http://download.geofabrik.de/asia/vietnam-latest.osm.pbf

# Pre-process the OSM data file (extract, partition, and customize)
RUN osrm-extract -p /opt/car.lua /data/vietnam-latest.osm.pbf && \
    osrm-partition /data/vietnam-latest.osrm && \
    osrm-customize /data/vietnam-latest.osrm

# Expose the OSRM routing server on port 5000
EXPOSE 5000

# Start the OSRM routing server
CMD ["osrm-routed", "--algorithm", "mld", "/data/vietnam-latest.osrm"]