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
	let poiMarkers: mapboxgl.Marker[] = [];
	let showFilters = false; // To track if filters should be displayed
	let selectedCountryISO: string | null = null; // Track the selected country
	let baselineZoom: number | null = null;
	let activeFilter: string | null = null;
	let visibleRecommendedMarkers = [];
	let isRecommendedActive = false;
	let allRecommendedMarkers = [];
	let isRemoveActive = false;

	// Load JSON file based on selected month
	async function loadData(type: 'recommendations' | 'filter', identifier: string, filter?: string) {
		const filePath =
			type === 'recommendations'
				? `/recommendations/${identifier.toLowerCase()}_recommendations.json`
				: `/${filter}/${identifier.toLowerCase()}_${filter}.json`;

		try {
			const response = await fetch(filePath);
			if (response.ok) {
				const data = await response.json();
				if (type === 'recommendations') {
					countryRecommendationData = [...new Set(data)];
					applyRecommendationDataToGlobe(countryRecommendationData);
				} else if (type === 'filter') {
					console.log('Filter Data:', data);
					applyFilterDataToGlobe(data, filter!);
				}
			} else {
				console.error(`Failed to load ${type} data for ${identifier}`);
			}
		} catch (error) {
			console.error(`Error fetching ${type} data:`, error);
		}
	}

	async function loadPOIData(countryISO: string, zoomLevel?: number) {
		console.log(`Loading POI data for: ${countryISO} at zoom level: ${zoomLevel || 'N/A'}`);
		try {
			const response = await fetch(`/markers/${countryISO.toLowerCase()}.json`);
			if (response.ok) {
				const data = await response.json();

				if (activeFilter) {
					console.log(`Filter active (${activeFilter}). POIs will not be overridden.`);
					return;
				}

				const { recommended } = data.poi;

				let filteredPOIs = recommended;
				if (zoomLevel !== undefined) {
					filteredPOIs = filteredPOIs.filter(
						(poi) => poi.zoomLevel === undefined || poi.zoomLevel <= zoomLevel
					);
				}

				isRecommendedActive = true;
				allRecommendedMarkers = recommended;
				visibleRecommendedMarkers = filteredPOIs;

				clearMarkers();
				addMarkersForPOIs(filteredPOIs);
			} else {
				console.error(`Failed to load POI data for: ${countryISO}`);
			}
		} catch (error) {
			console.error('Error fetching POI data:', error);
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

	function calculateHSL(
		hue: number,
		value: number,
		lightnessRange: [number, number],
		saturation: number = 100
	): string {
		const lightness = lightnessRange[0] - (value / 100) * (lightnessRange[0] - lightnessRange[1]);
		return `hsl(${hue}, ${saturation}%, ${lightness}%)`;
	}

	function getColorForRecommendation(value: number): string {
		const normalizedValue = Math.max(1, Math.min(value, 100));
		return calculateHSL(120, normalizedValue, [60, 40]);
	}

	function getColorForFilter(value: number, filter: string): string {
		if (filter === 'temperature') {
			const minTemp = -50;
			const maxTemp = 50;
			const normalizedTemp =
				Math.max(0, Math.min((value - minTemp) / (maxTemp - minTemp), 1)) * 100;
			const hue =
				normalizedTemp < 50
					? 240 - (normalizedTemp / 50) * 180
					: 60 - ((normalizedTemp - 50) / 50) * 60;

			return calculateHSL(hue, 100, [50, 50]);
		} else if (filter === 'danger') {
			const normalizedDanger = Math.max(0, Math.min(value, 100));

			return calculateHSL(0, normalizedDanger, [90, 20]);
		} else if (filter === 'rainfall') {
			const maxRainfall = 50;
			const normalizedRainfall = Math.max(0, Math.min(value / maxRainfall, 1)) * 100;

			return calculateHSL(240, normalizedRainfall, [60, 20]);
		}

		return 'rgba(0, 0, 0, 0)';
	}

	function resetView() {
		showFilters = false;
		selectedCountryISO = null;
		activeFilter = null;
		isRecommendedActive = false;
		isRemoveActive = false;
		allRecommendedMarkers = [];
		visibleRecommendedMarkers = [];
		if (map.getLayer('country-fills')) {
			map.setPaintProperty('country-fills', 'fill-color', 'rgba(0, 0, 0, 0)');
		}
	}

	// Handle month selection from the dropdown and load the recommendation data
	function handleMonthSelection(event: Event) {
		selectedMonth = (event.target as HTMLSelectElement).value;

		if (selectedMonth === 'none') {
			isMonthSelected = false;
			resetView();
		} else {
			isMonthSelected = true;
			selectedFilter = 'none';

			const radioButtons = document.getElementsByName('filter');
			radioButtons.forEach((radio: HTMLInputElement) => {
				if (radio.value === 'none') {
					radio.checked = true;
				}
			});

			loadData('recommendations', selectedMonth);
		}
	}

	// Handle filter selection (radio buttons)
	function handleFilterSelection(event: Event) {
		selectedFilter = (event.target as HTMLInputElement).value;
		if (selectedFilter === 'none') {
			// Revert to recommendations if "None" is selected
			loadData('recommendations', selectedMonth);
		} else if (selectedMonth && selectedFilter) {
			// Load filter data for the selected filter and month
			loadData('filter', selectedMonth, selectedFilter);
		}
	}

	function addMarkersForPOIs(pois) {
		pois.forEach((poi) => {
			const markerDiv = document.createElement('div');
			markerDiv.className = 'custom-marker';

			markerDiv.innerHTML = `
            <img src="${poi.image}" alt="${poi.name}" style="width: 40px; height: 40px; border-radius: 50%; border: 2px solid white;" />
        `;

			const marker = new mapboxgl.Marker(markerDiv)
				.setLngLat(poi.coordinates)
				.setPopup(
					new mapboxgl.Popup({ offset: 25 }).setHTML(`
                    <div style="text-align: center; max-width: 200px;">
                        <h3>${poi.name}</h3>
                        <img src="${poi.image}" alt="${poi.name}" style="width: 100%; border-radius: 8px;" />
                        <p>${poi.description}</p>
                    </div>
                `)
				)
				.addTo(map);

			markerDiv.addEventListener('click', () => {
				map.flyTo({
					center: poi.coordinates,
					zoom: Math.max(map.getZoom() + 2, 15),
					speed: 0.8,
					curve: 1.5
				});

				markerDiv.style.transform = 'scale(1.5)';

				poiMarkers.forEach((m) => {
					if (m.getElement() !== markerDiv) {
						m.getElement().style.transform = 'scale(1)';
					}
				});
			});

			poiMarkers.push(marker);
		});
	}

	function clearMarkers() {
		poiMarkers.forEach((marker) => marker.remove());

		poiMarkers = [];
	}

	const filters = [
		{ key: 'Recommended', icon: 'fa-solid fa-star', label: 'Recommended' },
		{ key: 'Beach', icon: 'fa-solid fa-umbrella-beach', label: 'Beach' },
		{ key: 'icons', icon: 'path-to-icon/icons.png', label: 'Icons' },
		{ key: 'amazing-views', icon: 'path-to-icon/amazing-views.png', label: 'Amazing views' },
		{ key: 'Remove', icon: 'fa-solid fa-ban', label: 'Remove' }
	];

	// Function to apply a filter
	async function applyFilter(filter: string) {
		if (!selectedCountryISO) {
			console.log(`Filter applied: ${filter}, but no country is currently selected`);
			return;
		}

		activeFilter = filter;

		try {
			const response = await fetch(`/markers/${selectedCountryISO.toLowerCase()}.json`);
			if (!response.ok) {
				console.error(`Failed to load markers for country: ${selectedCountryISO}`);
				return;
			}

			const data = await response.json();
			const filterMarkers = data.poi.filters[filter];

			if (!filterMarkers || filterMarkers.length === 0) {
				console.log(`No markers found for filter: ${filter} in country: ${selectedCountryISO}`);
				clearMarkers();
				activeFilter = null;
				return;
			}

			console.log(`Applying filter: ${filter} for country: ${selectedCountryISO}`);
			clearMarkers();
			addMarkersForPOIs(filterMarkers);
		} catch (error) {
			console.error(`Error applying filter: ${filter} for country: ${selectedCountryISO}`, error);
		}
	}

	async function applyRecommended() {
		if (!selectedCountryISO) {
			console.log(`Recommended button clicked, but no country is currently selected`);
			return;
		}

		activeFilter = null;
		isRecommendedActive = true;

		try {
			const response = await fetch(`/markers/${selectedCountryISO.toLowerCase()}.json`);
			if (!response.ok) {
				console.error(`Failed to load markers for country: ${selectedCountryISO}`);
				return;
			}

			const data = await response.json();
			allRecommendedMarkers = data.poi.recommended;

			if (!allRecommendedMarkers || allRecommendedMarkers.length === 0) {
				console.log(`No recommended markers found for country: ${selectedCountryISO}`);
				clearMarkers();
				return;
			}

			const currentZoom = map.getZoom();
			const filteredMarkers = allRecommendedMarkers.filter(
				(poi) => poi.zoomLevel === undefined || poi.zoomLevel <= currentZoom
			);

			console.log(`Applying recommended markers for country: ${selectedCountryISO}`);
			console.log('Filtered Recommended Markers:', filteredMarkers);

			clearMarkers();
			addMarkersForPOIs(filteredMarkers);
		} catch (error) {
			console.error(`Error applying recommended markers for country: ${selectedCountryISO}`, error);
		}
	}

	function resetSelectedCountry() {
		if (selectedCountryISO) {
			console.log('Resetting selected country and clearing states.');
			selectedCountryISO = null;
			showFilters = false; // Ensure filters are hidden
			isRecommendedActive = false;
			activeFilter = null;
			isRemoveActive = false;
			allRecommendedMarkers = [];
			visibleRecommendedMarkers = [];
			clearMarkers();

			if (selectedMonth) {
				console.log(`Reapplying recommendations for month: ${selectedMonth}`);
				loadData('recommendations', selectedMonth);
			} else {
				console.log('No filter or recommendations to apply. Resetting map.');
				resetView();
			}

			if (map.getLayer('country-fills')) {
				map.setPaintProperty('country-fills', 'fill-opacity', 0.75);
			}
		}
	}

	function clearAllMarkers() {
		console.log('Removing all markers from the map');
		clearMarkers();
		isRecommendedActive = false;
		activeFilter = null;
		visibleRecommendedMarkers = [];
		allRecommendedMarkers = [];
		isRemoveActive = true;
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

			map.addLayer({
				id: 'hover-outline',
				type: 'line',
				source: 'countries',
				layout: {},
				paint: {
					'line-color': '#000000',
					'line-width': 2,
					'line-opacity': ['case', ['boolean', ['feature-state', 'hover'], false], 1, 0]
				}
			});

			let hoveredCountryISO: string | null = null;

			map.on('mousemove', 'country-fills', (e) => {
				if (e.features.length > 0) {
					const hoveredFeature = e.features[0];
					const hoveredISO = hoveredFeature.properties.ISO_A3;

					if (hoveredCountryISO !== hoveredISO) {
						if (hoveredCountryISO !== null) {
							map.setPaintProperty('hover-outline', 'line-opacity', [
								'case',
								['==', ['get', 'ISO_A3'], hoveredCountryISO || ''],
								0,
								1
							]);
						}

						hoveredCountryISO = hoveredISO;
						map.setPaintProperty('hover-outline', 'line-opacity', [
							'case',
							['==', ['get', 'ISO_A3'], hoveredCountryISO],
							1,
							0
						]);
					}
				}
			});

			map.on('mouseleave', 'country-fills', () => {
				if (hoveredCountryISO !== null) {
					map.setPaintProperty('hover-outline', 'line-opacity', [
						'case',
						['==', ['get', 'ISO_A3'], hoveredCountryISO || ''],
						1,
						0
					]);
					hoveredCountryISO = null;
				}
			});

			let baselineZoom: number = null; // Store the baseline zoom level

			map.on('click', 'country-fills', (e) => {
				if (e.features.length > 0) {
					const country = e.features[0];
					const countryISO = country.properties.ISO_A3; // ISO_A3 code for identification
					const countryGeometry = country.geometry;
					selectedCountryISO = countryISO;
					showFilters = true;
					// Set the new selected country
					selectedCountryISO = countryISO;

					loadPOIData(countryISO);
					isRemoveActive = false;
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
						console.log(`Baseline Zoom Level: ${baselineZoom}`);

						// Load initial POIs for the selected country
						loadPOIData(countryISO, baselineZoom);
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

			map.on('zoomend', () => {
				const currentZoom = map.getZoom();
				console.log('Current Zoom Level:', currentZoom);

				if (selectedCountryISO) {
					if (currentZoom < baselineZoom) {
						console.log('Zoomed out past baseline. Resetting...');
						baselineZoom = null;
						showFilters = false;
						clearMarkers();
						resetSelectedCountry();
						resetView();
					} else if (activeFilter) {
						console.log(
							`Reapplying active filter: ${activeFilter} for country: ${selectedCountryISO}`
						);
						applyFilter(activeFilter);
					} else if (isRecommendedActive) {
						console.log('Reapplying recommended markers due to zoom change');
						const zoomFilteredMarkers = allRecommendedMarkers.filter(
							(poi) => poi.zoomLevel === undefined || poi.zoomLevel <= currentZoom
						);
						clearMarkers();
						addMarkersForPOIs(zoomFilteredMarkers);
					} else if (isRemoveActive) {
						console.log('Remove filter is active; keeping markers cleared');
						clearMarkers();
					}
				}
			});
		});
	}

	onDestroy(() => {
		if (map) map.remove();
	});
</script>

<head>
	<link href="https://api.mapbox.com/mapbox-gl-js/v2.14.1/mapbox-gl.css" rel="stylesheet" />
	<link
		href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
		rel="stylesheet"
	/>
</head>
<!-- Main Content -->
<!-- Main Content -->
<div use:initMap>
	<!-- Only render controls if we have content to show -->
	{#if !selectedCountryISO || showFilters}
		<!-- Month and radio controls -->
		{#if !selectedCountryISO}
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
							<input
								type="radio"
								name="filter"
								value="temperature"
								on:change={handleFilterSelection}
							/>
							Temperature
						</label>
						<label>
							<input type="radio" name="filter" value="danger" on:change={handleFilterSelection} /> Danger
						</label>
						<label>
							<input
								type="radio"
								name="filter"
								value="rainfall"
								on:change={handleFilterSelection}
							/> Rainfall
						</label>
					</div>
				{/if}
			</div>
		{/if}

		<!-- Vertical Filters in separate container -->
		{#if showFilters}
			<div class="filter-container-vertical">
				<!-- Recommended -->
				<div class="filter-item" on:click={applyRecommended}>
					<i class="fa-solid fa-star" />
					<span>Recommended</span>
				</div>

				<!-- Beach -->
				<div class="filter-item" on:click={() => applyFilter('Beach')}>
					<i class="fa-solid fa-umbrella-beach" />
					<span>Beach</span>
				</div>

				<!-- Landmarks -->
				<div class="filter-item" on:click={() => applyFilter('Landmarks')}>
					<i class="fa-solid fa-landmark" />
					<span>Landmarks</span>
				</div>

				<!-- Museums -->
				<div class="filter-item" on:click={() => applyFilter('Museums')}>
					<i class="fa-solid fa-palette" />
					<span>Museums</span>
				</div>

				<!-- Nature -->
				<div class="filter-item" on:click={() => applyFilter('Nature')}>
					<i class="fa-solid fa-tree" />
					<span>Nature</span>
				</div>

				<!-- Adventure -->
				<div class="filter-item" on:click={() => applyFilter('Adventure')}>
					<i class="fa-solid fa-hiking" />
					<span>Adventure</span>
				</div>

				<!-- Food -->
				<div class="filter-item" on:click={() => applyFilter('Food')}>
					<i class="fa-solid fa-utensils" />
					<span>Food</span>
				</div>

				<!-- Shopping -->
				<div class="filter-item" on:click={() => applyFilter('Shopping')}>
					<i class="fa-solid fa-shopping-bag" />
					<span>Shopping</span>
				</div>

				<!-- Nightlife -->
				<div class="filter-item" on:click={() => applyFilter('Nightlife')}>
					<i class="fa-solid fa-music" />
					<span>Nightlife</span>
				</div>

				<!-- Sports -->
				<div class="filter-item" on:click={() => applyFilter('Sports')}>
					<i class="fa-solid fa-football-ball" />
					<span>Sports</span>
				</div>

				<!-- Remove -->
				<div class="filter-item" on:click={clearAllMarkers}>
					<i class="fa-solid fa-ban" />
					<span>Remove</span>
				</div>
			</div>
		{/if}
	{/if}
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

	.filter-container-vertical {
		position: absolute;
		top: 20px;
		left: 20px;
		background-color: #fff;
		padding: 10px;
		border-radius: 8px;
		box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		display: flex;
		flex-direction: column;
		gap: 10px;
		width: 150px;
		max-height: 90vh;
		overflow-y: auto;
		z-index: 1000;
	}

	.filter-item {
		display: flex;
		flex-direction: column;
		align-items: center;
		cursor: pointer;
		text-align: center;
		color: #333;
		font-size: 14px;
		transition: transform 0.2s ease, color 0.2s ease;
	}

	.filter-item i {
		font-size: 20px;
		margin-bottom: 5px;
	}

	.filter-item:hover {
		transform: scale(1.1);
		color: #007bff;
	}

	.filter-item span {
		font-size: 12px;
		text-align: center;
	}

	.custom-marker {
		display: flex;
		justify-content: center;
		align-items: center;
		width: 40px;
		height: 40px;
		border-radius: 50%;
		background-color: rgba(255, 255, 255, 0.9);
		box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
		transition: transform 0.3s ease;
	}

	.custom-marker img {
		display: block;
		width: 100%;
		height: 100%;
		object-fit: cover;
		border-radius: 50%;
		pointer-events: none;
	}
</style>
