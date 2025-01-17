import { writable } from 'svelte/store';

// Create a writable store to hold the selected country's ISO code
export const selectedCountryISO = writable<string | null>(null);
