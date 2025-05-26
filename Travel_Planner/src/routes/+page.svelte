<script lang="ts">
	import { onDestroy, setContext } from 'svelte';
	import { mapboxgl, key } from './mapboxgl.js';
	import type { Map } from 'mapbox-gl';
	import * as turf from '@turf/turf';
	import { slide } from 'svelte/transition';
	import { Clock } from 'lucide-svelte';
	import { Calendar, Plane, ChevronLeft, ChevronRight } from 'lucide-svelte';
	import { MapPin, Train, Info } from 'lucide-svelte';

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
	let showSidebar = false;
	let sidebarContent = '';
	let activeTab = 'Info';
	let selectedPOI = null;
	let showModal = false;
	let countryPOIData = null;
	let filteredCountryPOI = [];
	let selectedActivities = [];
	let modalTabs = [
		'Recommended',
		'Beach',
		'Landmarks',
		'Museums',
		'Nature',
		'Adventure',
		'Food',
		'Shopping',
		'Nightlife',
		'Sports'
	];
	let modalActiveTab = modalTabs[0];
	let countriesData = [];
	let filteredCountries = [];
	let showItineraryModal = false;
	let itineraryData = null;
	let currentDayIndex = 0;

	let isLoadingItinerary = false;

	async function continueSelection() {
		isLoadingItinerary = true;
		showItineraryModal = true;
		const aiData = await testAI();
		if (aiData) {
			itineraryData = aiData;
		} else {
			generateItinerary();
		}
		isLoadingItinerary = false;
		currentDayIndex = 0;
	}
	function prevDay() {
		if (currentDayIndex > 0 && itineraryData?.days) {
			currentDayIndex--;
		}
	}

	function nextDay() {
		if (itineraryData?.days && currentDayIndex < itineraryData.days.length - 1) {
			currentDayIndex++;
		}
	}

	function generateItinerary() {
		itineraryData = {
			flightDetails: {
				arrival: {
					airport: 'Haneda Airport (HND)',
					date: 'June 15, 2024',
					time: '09:30',
					transport: 'Airport Limousine Bus to hotel (45 mins)',
					cost: '\u00a51,000 per person'
				},
				departure: {
					airport: 'Haneda Airport (HND)',
					date: 'June 20, 2024',
					time: '11:45',
					transport: 'Airport Limousine Bus from hotel (45 mins)',
					checkIn: '2 hours before flight',
					recommendedDeparture: '06:45',
					cost: '\u00a51,000 per person'
				}
			},
			days: [
				{
					activities: [
						{
							time: '09:00 - 11:00',
							category: 'Food & Culture',
							name: 'Tsukiji Outer Market',
							description: "Explore Japan's famous fish market and try fresh sushi",
							duration: '2 hours',
							location: 'Tsukiji',
							transport: '20 min subway from hotel',
							next: 'Next: 15 min subway to next location'
						},
						{
							time: '11:30 - 13:00',
							category: 'Nature',
							name: 'Hamarikyu Gardens',
							description: 'Traditional Japanese garden with tea ceremony',
							duration: '1.5 hours',
							location: 'Chuo City',
							transport: '15 min walk',
							next: 'Next: 25 min subway to next location'
						},
						{
							time: '14:00 - 16:00',
							category: 'Art',
							name: 'Teamlab Planets',
							description: 'Digital art museum with immersive installations',
							duration: '2 hours',
							location: 'Toyosu'
						}
					]
				},
				{
					activities: [
						{
							time: '08:30 - 10:30',
							category: 'Culture',
							name: 'Meiji Shrine',
							description: 'Historic Shinto shrine in a forest setting',
							duration: '2 hours',
							location: 'Shibuya',
							transport: '15 min subway from hotel',
							next: 'Next: 10 min walk to next location'
						},
						{
							time: '11:00 - 13:30',
							category: 'Shopping',
							name: 'Harajuku Shopping',
							description: 'Explore Takeshita Street and trendy boutiques',
							duration: '2.5 hours',
							location: 'Harajuku',
							transport: '10 min walk',
							next: 'Next: 5 min subway to next location'
						},
						{
							time: '14:00 - 16:00',
							category: 'Landmarks',
							name: 'Shibuya Sky',
							description: '360-degree view of Tokyo from observation deck',
							duration: '2 hours',
							location: 'Shibuya',
							transport: '5 min subway',
							next: 'Next: 15 min subway to hotel'
						}
					]
				}
			]
		};
	}
	import { HfInference } from '@huggingface/inference';

	async function testAI() {
		const token = import.meta.env.VITE_HF_TOKEN;
		if (!token) return null;

		const inference = new HfInference(token);
		const activities = selectedActivities;
		const activitiesPerDay = 2;
		const numberOfDays = Math.ceil(activities.length / activitiesPerDay);

		let message = `Return only a raw JSON object (no markdown, no backticks) for a travel itinerary with ${
			activities.length
		} activities across ${numberOfDays} days.
Rules:
1. Flight arrival time determines day 1: if the flight lands in the morning (e.g., 09:30), schedule activities in the afternoon or evening; if it lands in the evening, schedule only hotel check-in or minimal activities on day 1.
2. Activities that are typically nighttime (e.g., nightclubs) must be scheduled after 18:00.
3. All activity times must be logical based on the provided flight arrival and departure times.
Include exactly these activities: ${JSON.stringify(activities.map((a) => a.name))}.
Format must match: {"flightDetails":{"arrival":{"airport":"","date":"","time":"","transport":"","cost":""},"departure":{"airport":"","date":"","time":"","transport":"","checkIn":"","recommendedDeparture":"","cost":""}},"days":[{"activities":[{"time":"","category":"","name":"","description":"","duration":"","location":"","transport":"","next":""}]}]}`;

		try {
			const response = await inference.chatCompletion({
				model: 'Qwen/Qwen2.5-Coder-32B-Instruct',
				messages: [{ role: 'user', content: message }],
				max_tokens: 1024
			});
			const content = response.choices[0].message.content.trim();
			const cleanedContent = content.replace(/^```json\n|\n```$/g, '');
			return JSON.parse(cleanedContent);
		} catch (e) {
			console.error('AI_TEST Error:', e);
			return null;
		}
	}

	const tabs = ['Info', 'Transport', 'Tickets', 'Nearby', 'Photos'];

	function toggleSelection(activity) {
		const index = selectedActivities.findIndex((a) => a.name === activity.name);
		if (index >= 0) {
			selectedActivities = [
				...selectedActivities.slice(0, index),
				...selectedActivities.slice(index + 1)
			];
		} else {
			selectedActivities = [...selectedActivities, activity];
		}
		console.log(
			'Selected activities:',
			selectedActivities.map((a) => a.name)
		);
	}

	function cancelSelection() {
		selectedActivities = [];
		showModal = false;
	}

	async function loadCountryPOIData() {
		try {
			const response = await fetch(`/markers/${selectedCountryISO.toLowerCase()}.json`);
			if (response.ok) {
				countryPOIData = await response.json();
				updateFilteredPOI();
			} else {
				console.error(`Failed to load POI data for country: ${selectedCountryISO}`);
			}
		} catch (err) {
			console.error('Error loading country POI data:', err);
		}
	}

	function updateFilteredPOI() {
		if (!countryPOIData) {
			filteredCountryPOI = [];
			return;
		}
		if (modalActiveTab === 'Recommended') {
			filteredCountryPOI = countryPOIData.poi.recommended || [];
		} else {
			filteredCountryPOI =
				(countryPOIData.poi.filters && countryPOIData.poi.filters[modalActiveTab]) || [];
		}
	}

	function openItineraryModal() {
		if (!countryPOIData && selectedCountryISO) {
			loadCountryPOIData();
		} else {
			updateFilteredPOI();
		}
	}

	$: if (modalActiveTab) {
		updateFilteredPOI();
	}

	$: sidebarTabs =
		activeFilter === 'Beach'
			? ['Info', 'Transport', 'Prices', 'Nearby', 'Images']
			: activeFilter === 'Nature'
			? ['Info', 'Trails', 'Nearby', 'Weather', 'Photos']
			: activeFilter === 'Food'
			? ['Info', 'Menu', 'Photos']
			: activeFilter === 'Shopping'
			? ['Info', 'Directory', 'Photos']
			: activeFilter === 'Nightlife'
			? ['Info', 'Menu/Drinks', 'Photos']
			: activeFilter === 'Sports'
			? ['Info', 'Tickets', 'Photos']
			: activeFilter === 'Adventure'
			? ['Info', 'Activities', 'Photos']
			: ['Info', 'Transport', 'Tickets', 'Nearby', 'Photos'];

	async function loadCountriesData() {
		try {
			const response = await fetch(
				'https://raw.githubusercontent.com/datasets/geo-countries/master/data/countries.geojson'
			);
			if (response.ok) {
				const data = await response.json();
				countriesData = data.features;
				updateFilteredCountries();
			}
		} catch (err) {
			console.error(err);
		}
	}

	function updateFilteredCountries() {
		if (modalActiveTab === 'Recommended') {
			filteredCountries = countriesData;
		} else {
			filteredCountries = countriesData.filter((country) => {
				country.properties['ISO3166-1-Alpha-3'] == selectedCountryISO; //(modalActiveTab.charAt(0));
			});
		}
	}

	$: if (showModal && countriesData.length === 0) {
		loadCountriesData();
	}

	$: if (modalActiveTab) {
		updateFilteredCountries();
	}

	function computeDistance(coord1: number[], coord2: number[]): string {
		if (!coord1 || !coord2) return 'N/A';
		const from = turf.point(coord1);
		const to = turf.point(coord2);
		const distance = turf.distance(from, to, { units: 'kilometers' });
		return distance.toFixed(2);
	}

	const categoryLabels = {
		restaurantsAndCafes: 'Restaurants & Cafes',
		attractions: 'Attractions',
		publicTransport: 'Public Transport'
	};

	function setActiveTab(tab) {
		activeTab = tab;
	}

	function handleMarkerClick(poi) {
		showSidebar = true; // Show the sidebar
		selectedPOI = poi; // Store selected marker details
		activeTab = 'Info'; // Default tab when sidebar opens

		// Build sidebar content dynamically
		sidebarContent = `
        <div style="text-align: center;">
            <h2>${poi.name}</h2>
            <img src="${poi.image}" alt="${
			poi.name
		}" style="width: 100%; max-height: 200px; object-fit: cover; border-radius: 8px; margin-bottom: 10px;" />
            <p><strong>Description:</strong> ${poi.description}</p>
            ${poi.price ? `<p><strong>Price:</strong> ${poi.price}</p>` : ''}
            ${
							poi.howToGetThere
								? `<p><strong>How to Get There:</strong> ${poi.howToGetThere}</p>`
								: ''
						}
            ${
							poi.bestTimeToVisit
								? `<p><strong>Best Time to Visit:</strong> ${poi.bestTimeToVisit}</p>`
								: ''
						}
            ${
							poi.additionalInfo
								? `<p><strong>Additional Info:</strong> ${poi.additionalInfo}</p>`
								: ''
						}
        </div>
    `;
	}

	// Function to close the sidebar
	function closeSidebar() {
		const sidebar = document.querySelector('.sidebar');
		if (sidebar) {
			sidebar.classList.add('hidden');
			setTimeout(() => {
				showSidebar = false;
				selectedPOI = null; // Clear POI when closing sidebar
			}, 300);
		}
	}

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
		const matchExpression: (string | number)[] = ['match', ['get', 'ISO3166-1-Alpha-3']]; // ISO is the code in the json file
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
		const matchExpression: (string | number)[] = ['match', ['get', 'ISO3166-1-Alpha-3']];

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
		if (showSidebar) {
			showSidebar = false;
			selectedPOI = null;
		}
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

			markerDiv.addEventListener('click', (event) => {
				event.stopPropagation(); // Prevent click event from propagating to the map
				console.log(`Marker clicked: ${poi.name}, Coordinates: ${poi.coordinates}`);
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

			markerDiv.addEventListener('click', () => {
				handleMarkerClick(poi);
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

		// Store the current selectedPOI before potentially clearing it
		const previousSelectedPOI = selectedPOI;

		if (showSidebar) {
			showSidebar = false;
			selectedPOI = null;
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

			// Try to find a similar POI in the new filtered set
			if (previousSelectedPOI) {
				const similarPOI = filterMarkers.find(
					(poi) =>
						poi.name === previousSelectedPOI.name ||
						(poi.coordinates[0] === previousSelectedPOI.coordinates[0] &&
							poi.coordinates[1] === previousSelectedPOI.coordinates[1])
				);

				if (similarPOI) {
					// Directly set the sidebar and POI without using handleMarkerClick
					showSidebar = true;
					selectedPOI = similarPOI;
				}
			}
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

	function planItinerary() {
		if (!selectedCountryISO) {
			console.log('No country selected. Please select a country to plan an itinerary.');
			return;
		}
		console.log(`Planning itinerary for country: ${selectedCountryISO}`);
		showModal = true;
		openItineraryModal();
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
					const hoveredISO = hoveredFeature.properties['ISO3166-1-Alpha-3'];

					if (hoveredCountryISO != hoveredISO) {
						if (hoveredCountryISO != null) {
							map.setPaintProperty('hover-outline', 'line-opacity', 0);
						}

						hoveredCountryISO = hoveredISO;
						map.setPaintProperty('hover-outline', 'line-opacity', [
							'case',
							['==', ['get', 'ISO3166-1-Alpha-3'], hoveredCountryISO],
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
						['==', ['get', 'ISO3166-1-Alpha-3'], hoveredCountryISO || ''],
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
					const countryISO = country.properties['ISO3166-1-Alpha-3']; // ISO3166-1-Alpha-3 code for identification
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
						['==', ['get', 'ISO3166-1-Alpha-3'], countryISO],
						'rgba(0, 0, 0, 0)',
						'rgba(50, 50, 50, 0.8)'
					]);

					map.setPaintProperty('country-fills', 'fill-opacity', [
						'case',
						['==', ['get', 'ISO3166-1-Alpha-3'], countryISO],
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
						showSidebar = false;

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
	{#if showModal}
		<div class="modal">
			<div class="modal-content">
				<button class="close-modal" on:click={() => (showModal = false)}>×</button>
				<h2>Plan Itinerary</h2>
				<div class="modal-tabs">
					{#each modalTabs as tab}
						<button class:active={modalActiveTab === tab} on:click={() => (modalActiveTab = tab)}>
							{tab}
						</button>
					{/each}
				</div>
				<div class="modal-grid">
					{#if !countryPOIData}
						<p>Loading POI data...</p>
					{:else if filteredCountryPOI.length === 0}
						<p>No POIs for this category.</p>
					{:else}
						{#each filteredCountryPOI as poi}
							<div
								class="grid-item"
								class:selected={selectedActivities.some((a) => a.name === poi.name)}
								on:click={() => toggleSelection(poi)}
							>
								<img
									src={poi.image ||
										`https://via.placeholder.com/150?text=${encodeURIComponent(poi.name)}`}
									alt={poi.name}
								/>
								<p>{poi.name}</p>
							</div>
						{/each}
					{/if}
				</div>
				<div class="modal-controls">
					<span>Selected: {selectedActivities.length}</span>
					<button on:click={cancelSelection}>Cancel</button>
					<button on:click={continueSelection}>Continue</button>
				</div>
			</div>
		</div>
		{#if showItineraryModal}
			<div class="itinerary-modal">
				<button class="close-modal" on:click={() => (showItineraryModal = false)}>×</button>
				<div class="itinerary-content">
					{#if isLoadingItinerary}
						<div class="loading">Generating your itinerary...</div>
					{:else if itineraryData}
						<div class="itinerary-modal">
							<button class="close-modal" on:click={() => (showItineraryModal = false)}>×</button>
							<div class="itinerary-content">
								<div class="trip-details-card">
									<h2 class="card-title">Flight Details</h2>
									<div class="details-grid">
										<!-- Arrival Section -->
										<div class="flight-section">
											<h3 class="section-title">
												<span class="icon-wrapper arrival">
													<Plane size={16} />
												</span>
												Arrival
											</h3>
											<div class="details-list">
												<p>
													Airport: <span class="highlight"
														>{itineraryData.flightDetails.arrival.airport}</span
													>
												</p>
												<p>
													Transport: <span>{itineraryData.flightDetails.arrival.transport}</span>
												</p>
												<p>
													Transport Cost: <span>{itineraryData.flightDetails.arrival.cost}</span>
												</p>
											</div>
										</div>

										<!-- Departure Section -->
										<div class="flight-section">
											<h3 class="section-title">
												<span class="icon-wrapper departure">
													<Plane size={16} />
												</span>
												Departure
											</h3>
											<div class="details-list">
												<p>
													Airport: <span class="highlight"
														>{itineraryData.flightDetails.departure.airport}</span
													>
												</p>
												<p>
													Transport: <span>{itineraryData.flightDetails.departure.transport}</span>
												</p>
												<p>
													Transport Cost: <span>{itineraryData.flightDetails.departure.cost}</span>
												</p>
											</div>
										</div>
									</div>
								</div>

								<!-- [DAY NAVIGATION] -->
								<div class="day-navigation">
									<div class="current-day">
										<Calendar size={20} class="calendar-icon" />
										<h2>Day {currentDayIndex + 1}</h2>
									</div>
									<div class="nav-buttons">
										<button
											on:click={() => prevDay()}
											disabled={currentDayIndex === 0}
											aria-label="Previous day"
										>
											<ChevronLeft size={20} />
										</button>
										<button
											on:click={() => nextDay()}
											disabled={currentDayIndex === (itineraryData?.days?.length || 1) - 1}
											aria-label="Next day"
										>
											<ChevronRight size={20} />
										</button>
									</div>
								</div>

								<!-- [TIMELINE STRIP] -->
								<div class="timeline-wrapper">
									<div class="timeline-container">
										{#each itineraryData.days[currentDayIndex].activities as activity, i (i)}
											<div class="timeline-item">
												<div class="timeline-content">
													<div class="dot" />
													<div class="timeline-info">
														<span class="time">{activity.time.split(' - ')[0]}</span>
														<span class="activity-name">{activity.name}</span>
													</div>
												</div>
												{#if i < itineraryData.days[currentDayIndex].activities.length - 1}
													<div class="connector" />
												{/if}
											</div>
										{/each}
									</div>
								</div>

								<!-- [ACTIVITY CARDS - STACK] -->
								<div class="activity-cards">
									{#each itineraryData.days[currentDayIndex].activities as activity}
										<div class="activity-card">
											<div class="activity-image">
												<img src={activity.image || 'images/beach.jpg'} alt={activity.name} />
											</div>
											<div class="activity-details">
												<div class="header">
													<div class="title-section">
														<span class="category-tag">{activity.category}</span>
														<h3 class="activity-title">{activity.name}</h3>
													</div>
													<span class="time">{activity.time}</span>
												</div>

												<p class="description">{activity.description}</p>

												<div class="info-grid">
													<div class="info-item">
														<Clock size={18} />
														<span>{activity.duration}</span>
													</div>
													<div class="info-item">
														<MapPin size={18} />
														<span>{activity.location}</span>
													</div>
													<div class="info-item">
														<Train size={18} />
														<span>{activity.transport}</span>
													</div>
													<div class="info-item next-transport">
														<Info size={18} />
														<span>Next: {activity.next}</span>
													</div>
												</div>
											</div>
										</div>
									{/each}
								</div>
							</div>
						</div>
					{/if}
				</div>
			</div>
		{/if}
	{/if}

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

				<!-- Plan Itinerary Button -->
				<div class="plan-itinerary" on:click={planItinerary}>
					<button>Plan Itinerary</button>
				</div>
			</div>
		{/if}
	{/if}
	{#if showSidebar}
		<div class="sidebar">
			<!-- Header with Name and Close Button -->
			<div class="sidebar-header">
				<h3>{selectedPOI.name}</h3>
				<button class="close-btn" on:click={closeSidebar}>×</button>
			</div>

			<!-- Tab Navigation -->
			<div class="tab-navigation">
				{#each sidebarTabs as tab}
					<button class:active={activeTab === tab} on:click={() => (activeTab = tab)}>
						{#if tab === 'Info'}
							<i class="fa-solid fa-circle-info" />
						{:else if tab === 'Transport'}
							<i class="fa-solid fa-bus" />
						{:else if tab === 'Tickets' || tab === 'Prices'}
							<i class="fa-solid fa-ticket-alt" />
						{:else if tab === 'Nearby'}
							<i class="fa-solid fa-map-marker-alt" />
						{:else if tab === 'Photos' || tab === 'Images'}
							<i class="fa-solid fa-camera" />
						{/if}
						{tab}
					</button>
				{/each}
			</div>

			<!-- Tab Content -->
			<div class="tab-content">
				{#if activeTab === 'Info'}
					<div style="font-family: Arial, sans-serif; font-size: 14px; color: #333;">
						<!-- Image -->
						<img
							src={selectedPOI.image}
							alt={selectedPOI.name}
							style="width: 100%; max-height: 200px; object-fit: cover; border-radius: 8px; margin-bottom: 10px;"
						/>
						<!-- Additional Info Section -->
						<div style="margin-top: 15px;">
							{#if selectedPOI.location}
								<div style="display: flex; align-items: center; margin-bottom: 10px;">
									<i
										class="fa-solid fa-map-marker-alt"
										style="margin-right: 10px; color: #007bff;"
									/>
									<span>{selectedPOI.location}</span>
								</div>
							{/if}
							{#if selectedPOI.openingHours}
								<div style="display: flex; align-items: center; margin-bottom: 10px;">
									<i class="fa-solid fa-clock" style="margin-right: 10px; color: #007bff;" />
									<span>{selectedPOI.openingHours}</span>
								</div>
							{/if}
							{#if selectedPOI.price}
								<div style="display: flex; align-items: center; margin-bottom: 10px;">
									<i class="fa-solid fa-ticket-alt" style="margin-right: 10px; color: #007bff;" />
									<span>{selectedPOI.price}</span>
								</div>
							{/if}
							{#if selectedPOI.additionalInfo}
								<div style="margin-top: 10px;">
									<strong>More Info:</strong>
									{selectedPOI.additionalInfo}
								</div>
							{/if}
						</div>
					</div>
				{:else if activeTab === 'Transport'}
					{#if selectedPOI.transport}
						<div
							style="font-family: Arial, sans-serif; font-size: 14px; color: #333; line-height: 1.6;"
						>
							<!-- Metro Stations -->
							{#if selectedPOI.transport.metroStations && selectedPOI.transport.metroStations.length > 0}
								<p><strong>Metro Stations:</strong></p>
								<ul style="margin: 10px 0; padding-left: 20px;">
									{#each selectedPOI.transport.metroStations as station}
										<li style="margin-bottom: 5px;">{station}</li>
									{/each}
								</ul>
							{/if}
							<!-- Bus Lines -->
							{#if selectedPOI.transport.busLines && selectedPOI.transport.busLines.length > 0}
								<p style="margin-top: 10px;"><strong>Bus Lines:</strong></p>
								<ul style="margin: 10px 0; padding-left: 20px;">
									{#each selectedPOI.transport.busLines as line}
										<li style="margin-bottom: 5px;">{line}</li>
									{/each}
								</ul>
							{/if}
							<!-- Parking -->
							{#if selectedPOI.transport.parking}
								<p style="margin-top: 10px;">
									<strong>Parking:</strong>
									{selectedPOI.transport.parking}
								</p>
							{/if}
						</div>
					{:else}
						<p style="font-family: Arial, sans-serif; font-size: 14px; color: #777;">
							No transport information available.
						</p>
					{/if}
				{:else if activeTab === 'Tickets' || activeTab === 'Prices'}
					<div style="font-family: Arial, sans-serif; font-size: 14px; color: #333;">
						{#if activeFilter === 'Beach'}
							<p><strong>Pricing:</strong></p>
							{#if selectedPOI.pricing}
								<ul>
									{#each Object.keys(selectedPOI.pricing) as key}
										<li>
											<strong>{key}:</strong>
											{selectedPOI.pricing[key]}
										</li>
									{/each}
								</ul>
							{:else}
								<p>No pricing information available.</p>
							{/if}
						{:else if selectedPOI.tickets}
							<p><strong>Tickets Info:</strong></p>
							<p>{selectedPOI.tickets.notes}</p>
						{:else}
							<p>No ticket information available.</p>
						{/if}
					</div>
				{:else if activeTab === 'Nearby'}
					{#if selectedPOI.nearby && typeof selectedPOI.nearby === 'object'}
						<div
							style="font-family: Arial, sans-serif; font-size: 14px; color: #333; line-height: 1.6;"
						>
							{#each Object.keys(selectedPOI.nearby) as category}
								<h4 style="margin-bottom: 8px;">{categoryLabels[category] || category}</h4>
								<ul style="margin: 10px 0; padding-left: 0; list-style: none;">
									{#each selectedPOI.nearby[category] as place}
										<li style="display: flex; align-items: center; margin-bottom: 10px;">
											<i
												class="fa-solid fa-map-marker-alt"
												style="margin-right: 10px; color: #007bff;"
											/>
											<span>
												<strong>{place.name}</strong> ({computeDistance(
													selectedPOI.coordinates,
													place.coordinates
												)} km)
											</span>
										</li>
									{/each}
								</ul>
							{/each}
						</div>
					{:else}
						<p style="font-family: Arial, sans-serif; font-size: 14px; color: #777;">
							No nearby places available.
						</p>
					{/if}
				{:else if activeTab === 'Photos' || activeTab === 'Images'}
					<div style="display: flex; flex-wrap: wrap; gap: 10px;">
						{#each selectedPOI.photos as photo}
							<img
								src={photo}
								alt="Photo of {selectedPOI.name}"
								style="width: 100%; max-height: 200px; object-fit: cover; border-radius: 8px;"
							/>
						{/each}
					</div>
				{/if}
			</div>
		</div>
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
		top: 10px;
		bottom: 10px;
		left: 20px;
		background-color: #fff;
		padding: 10px;
		border-radius: 8px;
		box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		gap: 10px;
		width: 120px;
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
		font-size: 16px;
		margin-bottom: 5px;
	}

	.filter-item:hover {
		transform: scale(1.1);
		color: #007bff;
	}

	.filter-item span {
		font-size: 10px;
		text-align: center;
	}

	.plan-itinerary {
		margin-top: 20px;
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.plan-itinerary button {
		background-color: #007bff;
		color: white;
		border: none;
		padding: 10px 20px;
		border-radius: 5px;
		font-size: 16px;
		cursor: pointer;
		transition: background-color 0.3s ease, transform 0.3s ease;
	}

	.plan-itinerary button:hover {
		background-color: #0056b3;
		transform: scale(1.05);
	}

	.close-btn {
		align-self: flex-end;
		background: none;
		border: none;
		font-size: 24px;
		cursor: pointer;
		margin-bottom: 20px;
		color: #333;
		transition: colour 0.3s ease;
	}

	.close-btn:hover {
		color: red;
	}

	.sidebar {
		position: fixed;
		right: 0;
		top: 0;
		bottom: 0;
		width: 500px; /* Adjust width if necessary */
		background: #fff;
		border-left: 1px solid #ccc;
		box-shadow: -2px 0 5px rgba(0, 0, 0, 0.1);
		padding: 20px;
		overflow-y: auto;
		display: flex;
		flex-direction: column;
	}

	.sidebar-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 15px;
		padding-bottom: 10px;
		border-bottom: 1px solid #ccc;
	}

	.sidebar-header h3 {
		margin: 0;
		font-size: 18px;
		color: #333;
	}

	.close-btn {
		background: none;
		border: none;
		font-size: 24px;
		cursor: pointer;
		color: #333;
		transition: color 0.3s ease;
	}

	.close-btn:hover {
		color: red;
	}

	.tab-navigation {
		display: flex;
		justify-content: space-around;
		background-color: #f9f9f9;
		padding: 10px;
		border-radius: 8px;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
		margin-bottom: 15px; /* Space between navigation and content */
	}

	.tab-navigation button {
		flex: none;
		min-width: 80px;
		background-color: transparent;
		border: none;
		padding: 10px;
		font-size: 14px;
		color: #666;
		cursor: pointer;
		display: flex;
		align-items: center;
		justify-content: center;
		border-radius: 5px;
		transition: background-color 0.2s, color 0.2s;
		text-align: center;
	}

	.tab-navigation button i {
		font-size: 16px;
		margin-right: 5px;
	}

	.tab-navigation button:hover {
		background-color: #eaeaea;
		color: #000;
	}

	.tab-navigation button.active {
		background-color: #ffffff;
		color: #000;
		font-weight: bold;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}

	.fa-map-marker-alt,
	.fa-clock,
	.fa-ticket-alt {
		font-size: 14px;
	}

	.modal {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: rgba(0, 0, 0, 0.5);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 2000;
	}

	.modal-content {
		background: #fff;
		padding: 20px;
		border-radius: 8px;
		width: 90%;
		height: 90%;
		overflow: auto;
		position: relative;
	}

	.close-modal {
		position: absolute;
		top: 10px;
		right: 10px;
		background: none;
		border: none;
		font-size: 24px;
		cursor: pointer;
	}

	.modal-tabs {
		display: flex;
		gap: 10px;
		margin-bottom: 20px;
	}

	.modal-tabs button {
		padding: 8px 12px;
		background: #f0f0f0;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		transition: background 0.2s;
	}

	.modal-tabs button.active {
		background: #007bff;
		color: #fff;
	}

	.modal-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
		gap: 10px;
	}

	.grid-item {
		text-align: center;
	}

	.grid-item img {
		width: 100%;
		border-radius: 4px;
	}

	.grid-item.selected {
		border: 2px solid #007bff;
		background-color: rgba(0, 123, 255, 0.1);
	}

	.modal-controls {
		position: absolute;
		bottom: 20px;
		right: 20px;
		display: flex;
		align-items: center;
		gap: 10px;
	}

	.modal-controls span {
		font-size: 14px;
	}

	.modal-controls button {
		padding: 8px 12px;
		background: #007bff;
		border: none;
		color: #fff;
		border-radius: 4px;
		cursor: pointer;
		transition: background 0.2s;
	}

	.modal-controls button:hover {
		background: #0056b3;
	}

	.itinerary-modal {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: rgba(0, 0, 0, 0.7);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 3000;
	}

	.itinerary-content {
		background: #fff;
		padding: 30px;
		border-radius: 8px;
		width: 95%;
		height: 90%;
		overflow: auto;
		position: relative;
	}

	.close-modal {
		position: absolute;
		top: 15px;
		right: 15px;
		background: none;
		border: none;
		font-size: 30px;
		cursor: pointer;
		color: #333;
	}

	.day-navigation {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 20px;
	}

	.day-navigation .current-day {
		display: flex;
		align-items: center;
		gap: 10px;
		font-size: 18px;
	}

	.day-navigation .nav-buttons button {
		background: #007bff;
		color: #fff;
		border: none;
		padding: 8px 12px;
		border-radius: 4px;
		cursor: pointer;
		font-size: 16px;
	}

	.day-navigation .nav-buttons button:disabled {
		background: #ccc;
		cursor: not-allowed;
	}

	.timeline-container {
		@apply relative flex justify-between items-center w-full px-4;
	}

	.timeline-item {
		@apply flex-1 relative flex items-center;
	}

	.timeline-content {
		@apply flex flex-col items-center relative z-10;
	}

	.timeline-info {
		@apply flex flex-col items-center mt-2 text-center;
	}

	.activity-name {
		@apply text-sm font-medium text-gray-800 max-w-[120px] truncate;
	}

	@keyframes pulse {
		0% {
			box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.4);
		}
		70% {
			box-shadow: 0 0 0 6px rgba(59, 130, 246, 0);
		}
		100% {
			box-shadow: 0 0 0 0 rgba(59, 130, 246, 0);
		}
	}

	.activity-cards {
		display: flex;
		flex-direction: column;
		gap: 20px;
	}

	.activity-card {
		display: flex;
		gap: 20px;
		border: 1px solid #eee;
		border-radius: 8px;
		overflow: hidden;
	}

	.activity-image {
		flex: 1;
	}

	.activity-image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.activity-details {
		flex: 2;
		padding: 10px;
	}

	.activity-details .time {
		font-size: 14px;
		color: #555;
	}

	.details-grid {
		display: grid;
		grid-template-columns: repeat(2, 1fr);
		gap: 10px;
		margin-top: 10px;
	}

	.trip-details-card {
		background-color: white;
		border-radius: 12px;
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
		padding: 20px 24px;
		margin-bottom: 24px;
		width: 100%;
	}

	.card-title {
		font-size: 20px;
		font-weight: 600;
		margin-bottom: 20px;
		color: #1a1a1a;
	}

	.details-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 40px;
	}

	.flight-section {
		display: flex;
		flex-direction: column;
		gap: 12px;
	}

	.section-title {
		font-size: 14px;
		font-weight: 500;
		display: flex;
		align-items: center;
		color: #1a1a1a;
		margin-bottom: 4px;
	}

	.icon-wrapper {
		margin-right: 6px;
		display: inline-flex;
	}

	.arrival {
		transform: rotate(45deg);
	}

	.departure {
		transform: rotate(-45deg);
	}

	.details-list {
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.details-list p {
		font-size: 14px;
		line-height: 1.5;
		margin: 0;
		color: #374151;
	}

	.highlight {
		color: rgb(37, 99, 235);
	}

	@media (max-width: 768px) {
		.details-grid {
			grid-template-columns: 1fr;
			gap: 24px;
		}
	}

	.day-navigation {
		display: flex;
		justify-content: space-between;
		align-items: center;
		background-color: white;
		border-radius: 8px;
		padding: 12px 16px;
		margin-bottom: 24px;
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
	}

	.current-day {
		display: flex;
		align-items: center;
		gap: 12px;
	}

	h2 {
		font-size: 18px;
		font-weight: 600;
		color: #1a1a1a;
		margin: 0;
	}

	.nav-buttons {
		display: flex;
		gap: 8px;
	}

	button {
		display: flex;
		align-items: center;
		justify-content: center;
		background-color: white;
		border: none;
		border-radius: 6px;
		padding: 8px;
		color: #4b5563;
		cursor: pointer;
		transition: background-color 0.2s, opacity 0.2s;
	}

	button:hover:not(:disabled) {
		background-color: #f3f4f6;
	}

	button:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.timeline-wrapper {
		background-color: white;
		border-radius: 12px;
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
		padding: 20px;
		margin-bottom: 24px;
	}

	.timeline-container {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
		position: relative;
		padding: 0 10px;
	}

	.timeline-item {
		flex: 1;
		display: flex;
		align-items: center;
		position: relative;
	}

	.timeline-content {
		display: flex;
		flex-direction: column;
		align-items: center;
		position: relative;
		z-index: 2;
	}

	.dot {
		width: 12px;
		height: 12px;
		background-color: #3b82f6;
		border-radius: 50%;
		margin-bottom: 8px;
	}

	.timeline-info {
		display: flex;
		flex-direction: column;
		align-items: center;
		text-align: center;
	}

	.time {
		font-size: 14px;
		font-weight: 500;
		color: #1a1a1a;
		margin-bottom: 2px;
	}

	.activity-name {
		font-size: 14px;
		color: #6b7280;
		max-width: 120px;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.connector {
		position: absolute;
		top: 6px;
		left: 50%;
		right: -50%;
		height: 1px;
		background-color: #e5e7eb;
		z-index: 1;
	}

	.timeline-item:last-child .connector {
		display: none;
	}

	.activity-cards {
		display: flex;
		flex-direction: column;
		gap: 24px;
	}

	.activity-card {
		background: white;
		border-radius: 12px;
		overflow: hidden;
		display: flex;
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
	}

	.activity-image {
		width: 33.333%;
		position: relative;
	}

	.activity-image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.activity-details {
		width: 66.666%;
		padding: 24px;
		display: flex;
		flex-direction: column;
		gap: 16px;
	}

	.header {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
	}

	.title-section {
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.category-tag {
		display: inline-block;
		padding: 4px 12px;
		background-color: #eef2ff;
		color: #3b82f6;
		border-radius: 9999px;
		font-size: 14px;
		font-weight: 500;
	}

	.activity-title {
		font-size: 20px;
		font-weight: 600;
		color: #1a1a1a;
		margin: 0;
	}

	.time {
		font-size: 16px;
		font-weight: 500;
		color: #6b7280;
	}

	.description {
		color: #4b5563;
		font-size: 14px;
		line-height: 1.5;
		margin: 0;
	}

	.info-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 16px;
	}

	.info-item {
		display: flex;
		align-items: center;
		gap: 8px;
		color: #4b5563;
		font-size: 14px;
	}

	.next-transport {
		color: #3b82f6;
	}

	:global(.lucide) {
		display: inline-block;
		color: currentColor;
	}

	@media (max-width: 768px) {
		.activity-card {
			flex-direction: column;
		}

		.activity-image {
			width: 100%;
			height: 200px;
		}

		.activity-details {
			width: 100%;
		}
	}

	.loading {
		text-align: center;
		padding: 2rem;
		font-size: 1.2rem;
		color: #666;
	}
</style>
