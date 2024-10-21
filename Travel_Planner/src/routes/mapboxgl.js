import mapboxgl from 'mapbox-gl';

// https://docs.mapbox.com/help/glossary/access-token/
mapboxgl.accessToken = 'pk.eyJ1IjoiZG1hcmphbm92IiwiYSI6ImNtMmFqZ3FrNDBjY2UycXI0dnN5Y2R2OWgifQ.Qpp6VqFNovxvp7yN5UXbyw';

const key = Symbol();

export { mapboxgl, key };