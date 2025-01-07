<script lang="ts">
	import { onDestroy, setContext } from 'svelte';
	import { mapboxgl, key } from './mapboxgl.js';
	import type { Map } from 'mapbox-gl';
	import * as turf from '@turf/turf';

	setContext(key, {
		getMap: () => map
	});

	let map: Map;
	let countryRecommendationData = []; // To store country recommendation data
	let selectedMonth = ''; // Store the selected month for later use
	let selectedFilter = ''; // Store the selected filter (e.g., temp, danger, rainfall, etc.)
	let isMonthSelected = false;

	// Load JSON file based on selected month
	async function loadRecommendationData(month: string) {
		try {
			// Fetches the correct json file to be mapped onto the globe
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

	// Function to load filter data (e.g., temperature, danger, rainfall)
	async function loadFilterData(filter: string, month: string) {
		try {
			//why no work? filter month in lower case and the selected filter with an underscore. THAT IS FILE NAME
			//inspect element, console log with throw error or data used to know if it works
			const response = await fetch(`/${filter}/${month.toLowerCase()}_${filter}.json`);
			if (response.ok) {
				const data = await response.json();
				console.log('Filter Data:', data); // Check if data is loaded correctly
				applyFilterDataToGlobe(data, filter);
			} else {
				console.error(`Failed to load ${filter} data for ${month}`);
			}
		} catch (error) {
			console.error(`Error fetching ${filter} data:`, error);
		}
	}

	// Function to map recommendation data to the globe using colors
	function applyRecommendationDataToGlobe(data: any[]) {
		const matchExpression: (string | number)[] = ['match', ['get', 'ISO_A3']]; // ISO is the code in the json file
		data.forEach((row) => {
			const color = getColorForRecommendation(row.value);
			matchExpression.push(row.code, color);
		});
		matchExpression.push('rgba(0, 0, 0, 0)'); // Default color for countries with no data, the globe will be clear
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

	// Function to map filter data (e.g., temperature, danger, rainfall) to the globe using colors
	function applyFilterDataToGlobe(data: any[], filter: string) {
		const matchExpression: (string | number)[] = ['match', ['get', 'ISO_A3']];

		data.forEach((row) => {
			const value = row.value; // Always use 'value' for any filter

			// Ensure the value exists before applying it
			if (value !== undefined) {
				const color = getColorForFilter(value, filter); // Use the filter-specific color calculation
				console.log(`Country: ${row.code}, Value: ${value}, Color: ${color}`);
				matchExpression.push(row.code, color);
			}
		});

		matchExpression.push('rgba(0, 0, 0, 0)'); // Fallback color for countries without data
		console.log('Match Expression:', matchExpression);
		map.setPaintProperty('country-fills', 'fill-color', matchExpression as any);
	}

	// Color function for recommendations: dark gray for values <= 5, green for values > 5
	function getColorForRecommendation(value: number): string {
		// Ensure value is between 1 and 100
		const normalizedValue = Math.max(1, Math.min(value, 100));

		// Interpolate lightness: 40% (green) to 60% (gray)
		const lightness = 60 - (normalizedValue / 100) * 20;

		// Interpolate saturation: 100% (green) to 0% (gray)
		const saturation = (normalizedValue / 100) * 100;

		// Return the color as HSL, with a hue of 120 (green) and interpolated saturation and lightness
		return `hsl(120, ${saturation}%, ${lightness}%)`;
	}

	// Color function for temperature (yellow to red), danger (red), and rainfall (blue)
	function getColorForFilter(value: number, filter: string): string {
		if (filter === 'temperature') {
			// Normalize temperature: assuming -50 (coldest) to 50 (hottest)
			const minTemp = -50;
			const maxTemp = 50;
			const normalizedValue = (value - minTemp) / (maxTemp - minTemp); // Normalize between 0 and 1

			// Interpolate hue: from deep blue (240°) to red (0°), skipping green (no 120° hue) because colour theory i researched is for red to blue
			// Green (120° hue) would not be intutitve for the user
			// We transition directly from blue (240°) to yellow (60°) to red (0°)
			// All are rgb values
			const hue =
				normalizedValue < 0.5
					? 240 - normalizedValue * 2 * 60 // Blue to yellow range
					: 60 - (normalizedValue - 0.5) * 2 * 60; // Yellow to red range

			const saturation = 100; // Keep saturation at 100% for vibrant colors
			const lightness = 50; // Constant lightness for clear visibility

			// Return the color in HSL format
			return `hsl(${hue}, ${saturation}%, ${lightness}%)`;
		} else if (filter === 'danger') {
			// Normalize danger value: assuming danger is between 0 and 100
			const dangerValue = Math.min(value, 100);
			const lightness = 90 - (dangerValue / 100) * 70; // Map danger values to lightness (from 90% to 20%)
			return `hsl(0, 100%, ${lightness}%)`; // Red hue (0°), with varying lightness
		} else if (filter === 'rainfall') {
			// Normalize rainfall: assuming 0 to 50 mm as a typical range
			const maxRainfall = 50;
			const normalizedRainfall = Math.min(value / maxRainfall, 1);

			// Interpolate between light blue and dark blue
			const blueLightness = 60 - normalizedRainfall * 40; // 60% light blue to 20% dark blue
			return `hsl(240, 100%, ${blueLightness}%)`; // Blue hue (240°)
		}

		// Default colour for no data
		return 'rgba(0, 0, 0, 0)';
	}

	// Function to reset the globe to a plain view
	function resetGlobeToPlain() {
		if (map.getLayer('country-fills')) {
			map.setPaintProperty('country-fills', 'fill-color', 'rgba(0, 0, 0, 0)');
		}
	}

	// Handle month selection from the dropdown and load the recommendation data
	function handleMonthSelection(event: Event) {
		selectedMonth = (event.target as HTMLSelectElement).value;
		if (selectedMonth === 'none') {
			isMonthSelected = false;
			resetGlobeToPlain(); // Reset to the plain globe if no month is selected
		} else {
			isMonthSelected = true;
			loadRecommendationData(selectedMonth); // Load the default recommendation data
		}
	}

	// Handle filter selection (radio buttons)
	function handleFilterSelection(event: Event) {
		selectedFilter = (event.target as HTMLInputElement).value;
		if (selectedFilter === 'none') {
			// Revert to recommendations if "None" is selected
			loadRecommendationData(selectedMonth);
		} else if (selectedMonth && selectedFilter) {
			loadFilterData(selectedFilter, selectedMonth); // Load filter data for the selected month
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
				data: 'https://raw.githubusercontent.com/datasets/geo-countries/master/data/countries.geojson' // GeoJson is currently online, potentially move this locally in the future.
			});

			if (!map.getLayer('country-fills')) {
				map.addLayer({
					id: 'country-fills',
					type: 'fill',
					source: 'countries',
					layout: {},
					paint: {
						'fill-color': 'rgba(0, 0, 0, 0)',
						'fill-opacity': 0.75
					}
				});
			}

			let baselineZoom: number = null; // Store the baseline zoom level

			map.on('click', 'country-fills', (e) => {
				if (e.features.length > 0) {
					const country = e.features[0];
					const countryISO = country.properties.ISO_A3; // ISO_A3 code for identification
					const countryGeometry = country.geometry; // Get the geometry of the selected country

					// Calculate the bounding box of the selected country
					const bbox = turf.bbox(countryGeometry);

					map.fitBounds(bbox, {
						padding: 20,
						maxZoom: 7,
						duration: 1500,
						linear: true
					});

					map.once('moveend', () => {
						baselineZoom = map.getZoom();
					});

					map.setPaintProperty('country-fills', 'fill-color', [
						'case',
						['==', ['get', 'ISO_A3'], countryISO],
						'rgba(0, 0, 0, 0)',
						'rgba(50, 50, 50, 0.8)'
					]);

					map.setPaintProperty('country-fills', 'fill-opacity', [
						'case',
						['==', ['get', 'ISO_A3'], countryISO],
						0,
						1
					]);
				}
			});

			// Follow the zoom changes so that i know when to change the overlay of the other coutnries
			map.on('zoomend', () => {
				if (baselineZoom !== null) {
					const currentZoom = map.getZoom();

					if (currentZoom < baselineZoom) {
						map.setPaintProperty('country-fills', 'fill-opacity', 1);
						map.setPaintProperty('country-fills', 'fill-color', 'rgba(0, 0, 0, 0)');
					}
				}
			});
		});
	}

	onDestroy(() => {
		if (map) map.remove();
	});
</script>

<!-- Main Content -->
<div use:initMap>
	<!-- Control container for dropdown and radio buttons inline -->
	<div class="control-container">
		<!-- Dropdown for selecting a month -->
		<div class="dropdown-container">
			<select id="monthDropdown" on:change={handleMonthSelection}>
				<option value="none" selected>Select a Month</option>
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

		<!-- Conditionally show radio buttons only when a month is selected -->
		{#if selectedMonth !== 'none' && selectedMonth !== ''}
			<div class="radio-container">
				<label>
					<input
						type="radio"
						name="filter"
						value="none"
						on:change={handleFilterSelection}
						checked
					/> None
				</label>
				<label>
					<input type="radio" name="filter" value="temperature" on:change={handleFilterSelection} />
					Temperature
				</label>
				<label>
					<input type="radio" name="filter" value="danger" on:change={handleFilterSelection} /> Danger
				</label>
				<label>
					<input type="radio" name="filter" value="rainfall" on:change={handleFilterSelection} /> Rainfall
				</label>
			</div>
		{/if}
	</div>
</div>

<style>
	* {
		margin: 0;
		box-sizing: border-box;
		padding: 0;
	}

	:global(.mapboxgl-canvas-container) {
		width: 100vw;
		height: 100vh;
	}

	.control-container {
		position: absolute;
		top: 20px;
		left: 20px;
		background-color: #fff;
		padding: 15px 20px;
		border-radius: 8px;
		box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		display: flex;
		align-items: center;
		gap: 20px;
		z-index: 1000;
	}

	select {
		padding: 8px;
		font-size: 16px;
		border-radius: 5px;
		border: 1px solid #ccc;
		background-color: #f9f9f9;
		width: 200px;
	}

	label {
		font-size: 16px;
		margin-right: 10px;
		display: flex;
		align-items: center;
	}

	input[type='radio'] {
		margin-right: 5px;
	}

	.radio-container {
		display: flex;
		align-items: center;
		gap: 15px;
	}
</style>
