import L, {Map, TileLayer} from 'leaflet';
import '/src/style.css';

export function new_map(id, map_clicked_callback) {
    // --------------------------------------------------------------
    // configure new map
    // --------------------------------------------------------------
    const map = new Map(id).setView([51.505, -0.09], 13);
    const tiles = new TileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map);

    // --------------------------------------------------------------
    // configure map callbacks
    // --------------------------------------------------------------
    function on_map_click(e){
        var lat = e.latlng.lat
        var lng = e.latlng.lng
        map_clicked_callback(lat, lng)
    }
    map.on('click', on_map_click);
    return map
}
