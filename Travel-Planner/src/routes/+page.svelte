<script lang="ts">
	import { onDestroy, setContext } from 'svelte';
	import { mapboxgl, key } from './mapboxgl.js';
	import type { Map } from 'mapbox-gl';

	setContext(key, {
		getMap: () => map
	});

	let map: Map;
	let temperatureData: String[] = [];

	// Load JSON file with temperature data
	async function loadTemperatureData() {
		const response = await fetch('/average_temp.json');
		if (response.ok) {
			temperatureData = await response.json();
			temperatureData = [...new Set(temperatureData)];
		} else {
			console.error('Failed to load temperature data.');
		}
	}

	// Function to map temperature to a gradient color based on thresholds
	function getGradientColorByTemperature(temp: number): string {
		if (temp > 15) {
			const hue = 60 - ((temp - 15) / (30 - 15)) * 60;
			return `hsl(${hue}, 100%, 50%)`;
		} else {
			if (temp >= 0) {
				const lightness = 100 - (temp / 15) * 50;
				return `hsl(180, 100%, ${lightness}%)`;
			} else {
				const lightness = 50 + (-temp / 30) * 50;
				return `hsl(240, 100%, ${lightness}%)`;
			}
		}
	}

	// Initialize Mapbox map
	//first load the temp data and then the click layer on top so it is always the last layer
	async function initMap(container: HTMLDivElement) {
		await loadTemperatureData();

		map = new mapboxgl.Map({
			container: container,
			style: 'mapbox://styles/mapbox/light-v10',
			center: [0, 20],
			zoom: 1.5,
			projection: 'globe'
		});

		map.on('load', () => {
			map.addSource('countries', {
				type: 'geojson',
				data: 'https://raw.githubusercontent.com/datasets/geo-countries/master/data/countries.geojson'
			});

			// Build the match expression to map temperature data to gradient colors
			const matchExpression: (string | number)[] = ['match', ['get', 'ISO_A3']];

			// Loop over the temperature data and map each country to its gradient color
			for (const row of temperatureData) {
				const color = getGradientColorByTemperature(row.temp); // Get gradient color based on temperature
				matchExpression.push(row.code, color);
			}

			// Default color for countries with no data
			matchExpression.push('rgba(0, 0, 0, 0)');

			// Add a fill layer to color countries based on the temperature
			map.addLayer({
				id: 'country-fills',
				type: 'fill',
				source: 'countries',
				layout: {},
				paint: {
					'fill-color': matchExpression as any,
					'fill-opacity': 0.75
				}
			});

			// Add the clickable country border layer last so it's on top
			map.addLayer({
				id: 'country-borders',
				type: 'line',
				source: 'countries',
				paint: {
					'line-color': '#ffffff',
					'line-width': 1
				}
			});

			// Click event to log and show alert
			map.on('click', 'country-fills', (e) => {
				if (e.features.length > 0) {
					const country = e.features[0];
					console.log(`Clicked on country: ${country.properties.ADMIN}`);
					alert(`You clicked on ${country.properties.ADMIN}`);
				}
			});
		});
	}

	onDestroy(() => {
		if (map) map.remove();
	});
</script>

<div use:initMap></div>

<style>
	* {
		margin: 0;
		box-sizing: border-box;
		padding: 0;
		overflow: hidden;
		height: 100%;
	}
	:global(.mapboxgl-canvas-container) {
		width: 100vw;
		height: 100vh;
	}
</style>
