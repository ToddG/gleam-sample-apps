import { Map } from "maplibre-gl";

// uncommenting the following line breaks maplibre, it no longer displays
// import 'maplibre-gl/dist/maplibre-gl.css';

export function new_map(container: string): Map {
// this works but the map scrolls down
// w/o any user input
//
//     return new Map({
//         container: container,
//         style: "https://demotiles.maplibre.org/style.json", // stylesheet location
//         center: [-74.5, 40], // starting position [lng, lat]
//         zoom: 9, // starting zoom
//     });

// this works but the map scrolls down
// w/o any user input
    return new Map({
        container: container, // container id
        style: 'https://demotiles.maplibre.org/globe.json', // style URL
        center: [0, 0], // starting position [lng, lat]
        zoom: 2 // starting zoom
    });
}
