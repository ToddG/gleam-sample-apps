pub type LeafletMap

@external(javascript, "./leaflet_ffi_helper.mjs", "new_map")
pub fn new_map(msg: String, map_clicked_callback: fn(Float, Float) -> Nil) -> LeafletMap

