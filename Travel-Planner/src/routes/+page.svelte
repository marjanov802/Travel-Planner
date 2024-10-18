<script lang="ts">
	import { onDestroy, setContext } from 'svelte';
	import { mapboxgl, key } from './mapboxgl.js';
	import type { Map } from 'mapbox-gl';

	setContext(key, {
		getMap: () => map
	});

	// Define the structure of the temperature data using an interface
	interface TemperatureData {
		code: string;
		temp: number;
	}

	let map: Map;
	let temperatureData: TemperatureData[] = [];

	// Load JSON file with temperature data
	async function loadTemperatureData() {
		const response = await fetch('/average_temp.json'); // Adjust path if necessary
		if (response.ok) {
			temperatureData = await response.json();
		} else {
			console.error('Failed to load temperature data.');
		}
	}

	// Function to map temperature to a color
	function getColorByTemperature(temp: number): string {
		if (temp > 30) {
			return '#FF4500'; // Deep red for hot temperatures
		} else if (temp > 15) {
			return '#FFA500'; // Orange for warm temperatures
		} else if (temp > 0) {
			return '#FFFFE0'; // Light yellow/white for mild temperatures
		} else {
			return '#1E90FF'; // Deep blue for cold temperatures
		}
	}

	// Initialize Mapbox map
	async function initMap(container: HTMLDivElement) {
		// First, load the temperature data
		await loadTemperatureData();

		map = new mapboxgl.Map({
			container: container,
			style: 'mapbox://styles/mapbox/dark-v10', // You can choose any style you prefer
			center: [-103.5917, 40.6699], // Adjust this center as needed
			zoom: 2,
			projection: 'globe'
		});

		map.on('load', () => {
			// Add the country boundaries source (Mapbox's country boundaries dataset)
			map.addSource('countries', {
				type: 'vector',
				url: 'mapbox://mapbox.country-boundaries-v1'
			});

			// Build the match expression to map temperature data to colors
			const matchExpression: (string | number)[] = ['match', ['get', 'iso_3166_1_alpha_3'] as any];

			// Loop over the temperature data and map each country to its color
			for (const row of temperatureData) {
				const color = getColorByTemperature(row.temp); // Get color based on temperature range
				matchExpression.push(row.code, color);
			}

			// Default color for countries with no data
			matchExpression.push('rgba(0, 0, 0, 0)');

			// Add a fill layer to color countries based on the temperature
			map.addLayer({
				id: 'countries-fill',
				type: 'fill',
				source: 'countries',
				'source-layer': 'country_boundaries',
				paint: {
					'fill-color': matchExpression as any, // Cast to any to satisfy TypeScript's requirements
					'fill-opacity': 0.75
				}
			});
		});
	}

	// Clean up the map on destroy
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
