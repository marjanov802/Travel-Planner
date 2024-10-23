<script lang="ts">
	import { onDestroy, setContext } from 'svelte';
	import { mapboxgl, key } from './mapboxgl.js';
	import type { Map } from 'mapbox-gl';

	setContext(key, {
		getMap: () => map
	});

	let map: Map;
	let countryRecommendationData = []; // To store country recommendation data

	// Load JSON file based on selected month
	async function loadRecommendationData(month: string) {
		try {
			// Path to the file for the selected month (you can change this to match your structure)
			const response = await fetch(`/recommendations/${month.toLowerCase()}_recommendations.json`);
			if (response.ok) {
				const data = await response.json();
				countryRecommendationData = [...new Set(data)];
				applyRecommendationDataToGlobe(countryRecommendationData);
			} else {
				console.error(`Failed to load recommendation data for ${month}`);
			}
		} catch (error) {
			console.error('Error fetching recommendation data:', error);
		}
	}

	// Function to map recommendation data to the globe using colors
	function applyRecommendationDataToGlobe(data: any[]) {
		const matchExpression: (string | number)[] = ['match', ['get', 'ISO_A3']];

		// Loop over the data and map each country to its gradient color based on the recommendation value
		for (const row of data) {
			const color = getColorForRecommendation(row.value); // Calculate the color based on the recommendation value
			matchExpression.push(row.code, color); // Match country code to color
		}

		// Default color for countries with no data
		matchExpression.push('rgba(0, 0, 0, 0)');

		// Update the map layer with the new color data
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
		}
	}

	// Function to calculate color based on recommendation value
	function getColorForRecommendation(value: number): string {
		// Shades of green: stronger green for higher recommendation
		const hue = 120; // Green color
		const lightness = 100 - Math.min(value * 10, 100); // Darker green for higher values
		return `hsl(${hue}, 100%, ${lightness}%)`;
	}

	// Handle month selection from the dropdown and load the appropriate dataset
	function handleMonthSelection(event: Event) {
		const selectedMonth = (event.target as HTMLSelectElement).value;
		if (selectedMonth !== 'none') {
			loadRecommendationData(selectedMonth); // Load the appropriate recommendation data for the selected month
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
		});
	}

	onDestroy(() => {
		if (map) map.remove();
	});
</script>

<!-- Main Content -->
<div use:initMap>
	<!-- Dropdown for selecting a month -->
	<div class="dropdown-container">
		<label for="monthDropdown">Select a Month:</label>
		<select id="monthDropdown" on:change={handleMonthSelection}>
			<option value="none" disabled selected>Select a Month</option>
			<option value="January">January</option>
			<option value="February">February</option>
			<option value="March">March</option>
			<option value="April">April</option>
			<option value="May">May</option>
			<option value="June">June</option>
			<option value="July">July</option>
			<option value="August">August</option>
			<option value="September">September</option>
			<option value="October">October</option>
			<option value="November">November</option>
			<option value="December">December</option>
		</select>
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

	.dropdown-container {
		position: absolute;
		top: 20px;
		left: 20px;
		background-color: white;
		padding: 10px;
		border-radius: 5px;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		z-index: 1000;
		height: 10vh;
	}
	select {
		height: 10vh;
		padding: 5px;
		border-radius: 4px;
		border: 1px solid #ccc;
	}
</style>
