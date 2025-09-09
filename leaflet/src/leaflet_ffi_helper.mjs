import L, {Map, TileLayer} from 'leaflet';
// import "leaflet/dist/leaflet.css";
import '/src/style.css';

export function new_map(id) {
    console.log("id = " + id)
    const map = new Map(id).setView([51.505, -0.09], 13);
    console.log("map = " + map);
    const tiles = new TileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map);
    console.log("map = " + map);
    globalThis.L = L; // only for debugging in the developer console
    globalThis.map = map; // only for debugging in the developer console
    return map
}