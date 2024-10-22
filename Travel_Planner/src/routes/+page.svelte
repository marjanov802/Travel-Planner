<script lang="ts">
	import { onDestroy, setContext } from 'svelte';
	import { mapboxgl, key } from './mapboxgl.js';
	import type { Map } from 'mapbox-gl';

	setContext(key, {
		getMap: () => map
	});

	let map: Map;
	let temperatureData: any[] = [];

	// Function to load JSON file with temperature data dynamically based on the selected month
	async function loadTemperatureData(filePath: string) {
		const response = await fetch(filePath);
		if (response.ok) {
			temperatureData = await response.json();
			temperatureData = [...new Set(temperatureData)]; // Remove duplicates
			updateMapWithTemperatureData();
		} else {
			console.error('Failed to load temperature data from ' + filePath);
		}
	}

	// Function to handle the month selection and load the appropriate dataset
	function selectMonth(month: string) {
		let filePath = '';
		if (month === 'January') {
			filePath = '/average_temp.json'; // Path for January dataset
		} else if (month === 'July') {
			filePath = '/test_temp.json'; // Path for July dataset
		}
		loadTemperatureData(filePath); // Load the selected dataset
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
	async function initMap(container: HTMLDivElement) {
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

			// Initially update map with the default data (no color coding until a dataset is selected)
			updateMapWithTemperatureData();
		});
	}

	// Function to update the map colors with the loaded temperature data
	function updateMapWithTemperatureData() {
		const matchExpression: (string | number)[] = ['match', ['get', 'ISO_A3']];

		// Loop over the temperature data and map each country to its gradient color
		for (const row of temperatureData) {
			const color = getGradientColorByTemperature(row.temp); // Get gradient color based on temperature
			matchExpression.push(row.code, color);
		}

		// Default color for countries with no data
		matchExpression.push('rgba(0, 0, 0, 0)');

		// If the layer already exists, update it; otherwise, add the layer
		if (map.getLayer('country-fills')) {
			map.setPaintProperty('country-fills', 'fill-color', matchExpression as any);
		} else {
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

			map.addLayer({
				id: 'country-borders',
				type: 'line',
				source: 'countries',
				paint: {
					'line-color': '#ffffff',
					'line-width': 1
				}
			});
		}
	}

	// Cleanup map on destroy
	onDestroy(() => {
		if (map) map.remove();
	});
</script>

<!-- Main Content -->
<div use:initMap>
	<!-- Buttons to select month (January and July) -->
	<div class="buttons-container">
		<button class="btn btn-primary" on:click={() => selectMonth('January')}> January </button>
		<button class="btn btn-primary" on:click={() => selectMonth('July')}> July </button>
	</div>
</div>

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

	.buttons-container {
		display: flex;
		gap: 10px;
		z-index: 1000;
	}

	.btn {
		padding: 10px 20px;
		background-color: #4f46e5;
		color: white;
		font-weight: bold;
		border-radius: 8px;
		cursor: pointer;
	}

	.btn-primary {
		background-color: #1f2937;
		color: white;
	}

	.btn-primary:hover {
		background-color: #4f46e5;
	}
</style>
