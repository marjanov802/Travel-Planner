<script lang="ts">
	import { onDestroy, setContext } from 'svelte';
	import { mapboxgl, key } from './mapboxgl.js';
	import type { Map } from 'mapbox-gl';

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
			const response = await fetch(`/${filter}/${month.toLowerCase()}_${filter}.json`);
			if (response.ok) {
				const data = await response.json();
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
		const matchExpression: (string | number)[] = ['match', ['get', 'ISO_A3']];
		data.forEach((row) => {
			const color = getColorForRecommendation(row.value);
			matchExpression.push(row.code, color);
		});
		matchExpression.push('rgba(0, 0, 0, 0)'); // Default color for countries with no data
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
			const color = getColorForFilter(row.value, filter);
			matchExpression.push(row.code, color);
		});
		matchExpression.push('rgba(0, 0, 0, 0)');
		map.setPaintProperty('country-fills', 'fill-color', matchExpression as any);
	}

	// Color function for recommendations: dark gray for values <= 5, green for values > 5
	function getColorForRecommendation(value: number): string {
		if (value > 5) {
			return `hsl(120, 100%, 40%)`; // Strong green for values over 5
		} else {
			return `hsl(0, 0%, 60%)`; // Neutral gray for values <= 5
		}
	}

	// Color function for temperature (yellow to red), danger (red), and rainfall (blue)
	function getColorForFilter(value: number, filter: string): string {
		if (filter === 'temperature') {
			if (value > 10) {
				return 'red'; // Set color to red for values above 10
			} else {
				return 'rgba(0, 0, 0, 0.5)'; // Gray for lower values
			}
		} else if (filter === 'danger') {
			const hue = 0; // Red hue
			const lightness = 100 - Math.min(value * 10, 100); // Darker red for higher danger values
			return `hsl(${hue}, 100%, ${lightness}%)`;
		} else if (filter === 'rainfall') {
			if (value > 15) {
				return 'blue'; // Set color to blue for values above 15
			} else {
				return 'rgba(0, 0, 0, 0.5)'; // Gray for lower values
			}
		}
		return 'rgba(0, 0, 0, 0)'; // Default color for no data
	}

	// Function to reset the globe to a plain view
	function resetGlobeToPlain() {
		if (map.getLayer('country-fills')) {
			map.removeLayer('country-fills');
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
